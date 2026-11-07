#!/usr/bin/env python3
"""执行 URL 合同 ops/contract.tsv（docs/rebuild.md 第三节、5.5），只用 Python 标准库。

用法：
  对本机测试台的 Caddy（scripts/test-caddy.sh 会自动这样调用）：
    python3 -I ops/contract.py --local http://127.0.0.1:<端口> [--host writer.drakeet.com]
  在服务器上对正式站或预发站：按主机名连到本机 127.0.0.1 的 443 端口，带 SNI、校验证书，不经公网；
  路径写成 http:// 的行连本机 80 端口（scripts/deploy.sh 在切换版本之后这样调用）：
    python3 -I checks/contract.py --site writer.drakeet.com
    python3 -I checks/contract.py --site writer2.drakeet.com
  其他参数：
    --contract <文件>   合同表，默认是与本脚本同目录的 contract.tsv（服务器上的版本目录里两者都在 checks/ 下）
    --connect <地址>    --site 时连哪个地址，默认 127.0.0.1；排查时可以指向服务器的公网地址
    --verbose           逐行打印结果，不只是不通过的行

不跟随跳转。每一行逐项核对状态码、Location、Content-Type、响应头与内容；不符的逐条报告是哪一行、期望什么、实际什么。
退出状态：全部通过为 0；有任何一行不通过，或连续多行请求失败而提前停止，为 1；合同表本身写错或一行用例都没有，为 2。
表的格式见 contract.tsv 开头的注释。
"""

import argparse
import gzip
import http.client
import json
import pathlib
import re
import socket
import ssl
import sys
import zlib

TIMEOUT = 15

# 连续这么多行请求失败（连接不上、超时、连接被断开）就停止检查：站点多半整个不可用，再逐行等超时只会推迟回滚。
# 只数连接层面的失败；内容写错、状态码不符一类的不通过不算，那是逐行报告的正常结果。
MAX_CONSECUTIVE_REQUEST_ERRORS = 5
REQUEST_ERRORS = (OSError, http.client.HTTPException)

COLUMNS = ("路径", "请求头", "状态码", "Location", "Content-Type", "响应头", "内容")

# 路径列的特殊写法：「/css/* from /zh-hans/」表示 /zh-hans/ 页面里第一个以 /css/ 开头的地址（带内容指纹，文件名每次构建都会变）。
ASSET_FROM = re.compile(r"(/\S*/)\* from (/\S*)")

# 字段名与请求方法都是 RFC 9110 的 token（5.1、9.1）：至少一个字符，只含这些符号、数字与字母。写成「! Server」「Range :」
# 这类带空格的名字，查的就是一个不存在的头，否定断言永远通过、请求头发不对，所以加载时就拒绝。
TOKEN = re.compile(r"[!#$%&'*+.^_`|~0-9A-Za-z-]+")


class Row:
    def __init__(self, line_no, fields, method, send_headers, header_checks):
        self.line_no = line_no
        self.path, self.request_headers, self.status, self.location, self.content_type, self.response_headers, self.content = fields
        # 由 load_rows 解析好的请求方法、要带的请求头 [(名字, 值)] 与响应头的核对项 [(写法, 名字, 值)]。
        self.method = method
        self.send_headers = send_headers
        self.header_checks = header_checks


class Response:
    def __init__(self, status, headers, body):
        self.status = status
        self.headers = headers  # [(名字, 值)]，保留重复的字段
        self.body = body

    def header(self, name):
        """同名字段用逗号连起来；没有这个字段时返回 None。"""
        values = [value for key, value in self.headers if key.lower() == name.lower()]
        return ", ".join(values) if values else None

    def text(self):
        encoding = (self.header("Content-Encoding") or "").lower()
        if encoding == "gzip":
            # 截断或损坏的 gzip 正文算这一行不通过，不让整轮带着 traceback 中止。
            try:
                return gzip.decompress(self.body).decode("utf-8", "replace")
            except (EOFError, zlib.error, gzip.BadGzipFile) as error:
                raise ValueError(f"gzip 正文解压失败：{type(error).__name__}: {error}") from error
        if encoding:
            raise ValueError(f"响应经过 {encoding} 压缩，无法核对内容；这一行不要带 Accept-Encoding")
        return self.body.decode("utf-8", "replace")


class Target:
    """要检查的站点：本机测试台（HTTP）或服务器上的正式站、预发站（HTTPS，连本机地址、按主机名带 SNI）。"""

    def __init__(self, args):
        if args.local:
            match = re.fullmatch(r"http://([^/:]+):(\d+)/?", args.local)
            if not match:
                raise SystemExit("contract: --local 要写成 http://<地址>:<端口>")
            self.mode = "local"
            self.address, self.port = match.group(1), int(match.group(2))
            self.host = args.host
            self.description = f"{args.local}（Host: {self.host}）"
        else:
            self.mode = "site"
            self.address, self.port = args.connect, 443
            self.host = args.site
            self.description = f"https://{self.host}（连 {self.address}）"
        self._version = None

    def fetch(self, method, path, headers, plain_http=False):
        if self.mode == "local":
            conn = http.client.HTTPConnection(self.address, self.port, timeout=TIMEOUT)
        elif plain_http:
            conn = http.client.HTTPConnection(self.address, 80, timeout=TIMEOUT)
        else:
            conn = SNIConnection(self.address, self.host, timeout=TIMEOUT)
        try:
            # 不让 http.client 自动加 Accept-Encoding：没写这个请求头的行拿到的是未压缩的响应，内容才能核对。
            conn.putrequest(method, path, skip_host=True, skip_accept_encoding=True)
            conn.putheader("Host", self.host)
            for name, value in headers:
                conn.putheader(name, value)
            conn.endheaders()
            resp = conn.getresponse()
            body = resp.read()
            return Response(resp.status, resp.getheaders(), body)
        finally:
            conn.close()

    def version(self):
        """站点 /desktop2.json 里的版本号，替换路径里的 {version}（JAR 镜像里一定有当前版本的 JAR）。"""
        if self._version is None:
            resp = self.fetch("GET", "/desktop2.json", [])
            if resp.status != 200:
                raise ValueError(f"读取 /desktop2.json 得到 {resp.status}，无法替换 {{version}}")
            self._version = json.loads(resp.text())["version"]
        return self._version


class SNIConnection(http.client.HTTPSConnection):
    """连到指定地址，但 SNI 与证书校验都按主机名进行，相当于 curl --resolve <主机名>:443:<地址>。"""

    def __init__(self, address, host, timeout):
        super().__init__(host, 443, timeout=timeout, context=ssl.create_default_context())
        self._address = address

    def connect(self):
        sock = socket.create_connection((self._address, self.port), self.timeout)
        self.sock = self._context.wrap_socket(sock, server_hostname=self.host)


def load_rows(path):
    rows = []
    problems = []
    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip() or line.startswith("#"):
            continue
        fields = line.split("\t")
        if len(fields) != len(COLUMNS):
            problems.append(f"{path.name}:{line_no}：应有 {len(COLUMNS)} 列（用制表符分隔），实际 {len(fields)} 列")
            continue
        if not fields[2].isdigit():
            problems.append(f"{path.name}:{line_no}：状态码不是数字：{fields[2]}")
            continue
        # 请求头与响应头的写法在这里一次查完、解析好：表写错要在发出任何请求之前以 2 退出，而不是跑到那一行才按不通过报告。
        try:
            method, send_headers = parse_request_headers(fields[1])
        except ValueError as error:
            problems.append(f"{path.name}:{line_no}：{error}")
            continue
        header_checks = []
        bad_items = []
        for item in items(fields[5]):
            try:
                header_checks.append(parse_response_header(item))
            except ValueError as error:
                bad_items.append(f"{item}（{error}）")
        if bad_items:
            problems.append(f"{path.name}:{line_no}：响应头写法不对：{'；'.join(bad_items)}")
            continue
        rows.append(Row(line_no, fields, method, send_headers, header_checks))
    return rows, problems


def items(column):
    """列里的多项用「 | 」分隔；「-」表示没有。"""
    return [] if column == "-" else [item for item in column.split(" | ") if item]


def parse_response_header(item):
    """把响应头列里的一项解析成 (写法, 名字, 值)，写法是 absent、regex、equals、contains 之一；写法不对时抛出 ValueError。
    按「!」「 =~ 」「 == 」「: 」的顺序认写法，「!」后面只能直接跟字段名。"""
    if item.startswith("!"):
        kind, name, value = "absent", item[1:], None
    elif " =~ " in item:
        kind = "regex"
        name, value = item.split(" =~ ", 1)
        try:
            re.compile(value)
        except re.error as error:
            raise ValueError(f"正则写法不对：{error}") from error
    elif " == " in item:
        kind = "equals"
        name, value = item.split(" == ", 1)
    elif ": " in item:
        kind = "contains"
        name, value = item.split(": ", 1)
    else:
        raise ValueError("应写成「名字: 片段」「名字 == 值」「名字 =~ 正则」或「!名字」")
    if not TOKEN.fullmatch(name):
        raise ValueError(f"字段名为空或不是合法的 token：「{name}」")
    return kind, name, value


def parse_request_headers(column):
    """把请求头列解析成 (请求方法, [(名字, 值)])；写法不对时抛出 ValueError。"""
    method = "GET"
    headers = []
    for item in items(column):
        if item.startswith(":method:"):
            method = item[len(":method:"):].strip()
            if not TOKEN.fullmatch(method):
                raise ValueError(f"请求方法为空或不是合法的 token：{item}")
            continue
        name, sep, value = item.partition(":")
        if not sep:
            raise ValueError(f"请求头写法不对：{item}")
        if not TOKEN.fullmatch(name):
            raise ValueError(f"请求头的字段名为空或不是合法的 token：{item}")
        headers.append((name, value.strip()))
    return method, headers


def check_row(target, row):
    """返回 (结论, 说明列表)：结论是 pass、fail 或 skip。"""
    notes = []
    path = row.path.replace("{host}", target.host)
    plain_http = False
    if path.startswith("http://"):
        if target.mode == "local":
            return "skip", ["本机测试台只有 HTTP，没有到 HTTPS 的跳转"]
        plain_http = True
        path = re.sub(r"^http://[^/]+", "", path) or "/"
    if "{version}" in path:
        path = path.replace("{version}", target.version())
    asset = ASSET_FROM.fullmatch(path)
    if asset:
        prefix, page = asset.groups()
        page_resp = target.fetch("GET", page, [])
        page_text = page_resp.text()
        found = re.search(r"""(?:href|src)=["']?(""" + re.escape(prefix) + r"""[^"'\s>]+)""", page_text)
        if not found:
            return "fail", [f"{page}（{page_resp.status}）里没有指向 {prefix} 的地址"]
        path = found.group(1)
        notes.append(f"实际请求 {path}")

    resp = target.fetch(row.method, path, row.send_headers, plain_http=plain_http)
    failures = []

    if resp.status != int(row.status):
        failures.append(f"状态码：期望 {row.status}，实际 {resp.status}")

    location = resp.header("Location")
    if row.location == "-":
        if location is not None:
            failures.append(f"Location：期望没有，实际 {location}")
    else:
        expected = row.location.replace("{host}", target.host)
        if location != expected:
            failures.append(f"Location：期望 {expected}，实际 {location if location is not None else '没有'}")

    if row.content_type != "-":
        actual_type = resp.header("Content-Type") or ""
        accepted = items(row.content_type)
        if not any(actual_type.startswith(prefix) for prefix in accepted):
            failures.append(f"Content-Type：期望以 {' 或 '.join(accepted)} 开头，实际 {actual_type or '没有'}")

    for kind, name, value in row.header_checks:
        actual = resp.header(name)
        if kind == "absent":
            if actual is not None:
                failures.append(f"{name}：期望没有，实际 {actual}")
        elif kind == "regex":
            if actual is None or not re.fullmatch(value, actual):
                failures.append(f"{name}：期望整个值符合 {value}，实际 {actual or '没有'}")
        elif kind == "equals":
            if actual != value:
                failures.append(f"{name}：期望等于 {value}，实际 {actual or '没有'}")
        else:
            # contains：「名字: 片段」。
            if actual is None or value not in actual:
                failures.append(f"{name}：期望含有 {value}，实际 {actual or '没有'}")

    content_items = items(row.content)
    if content_items:
        text = resp.text()
        for item in content_items:
            if item.startswith("!"):
                if item[1:] in text:
                    failures.append(f"内容：不应含有 {item[1:]}")
            elif item not in text:
                failures.append(f"内容：期望含有 {item}")

    if failures:
        return "fail", failures + notes
    return "pass", notes


def describe(row):
    extra = f" [{row.request_headers}]" if row.request_headers != "-" else ""
    return f"{row.path}{extra}"


def main():
    parser = argparse.ArgumentParser(description="执行 URL 合同（ops/contract.tsv）")
    where = parser.add_mutually_exclusive_group(required=True)
    where.add_argument("--local", help="本机测试台的地址，例如 http://127.0.0.1:28080")
    where.add_argument("--site", help="服务器上要检查的主机名：writer.drakeet.com 或 writer2.drakeet.com")
    parser.add_argument("--host", default="writer.drakeet.com", help="--local 时请求带的 Host（默认 writer.drakeet.com）")
    parser.add_argument("--connect", default="127.0.0.1", help="--site 时连接的地址（默认 127.0.0.1）")
    parser.add_argument("--contract", type=pathlib.Path, default=pathlib.Path(__file__).resolve().with_name("contract.tsv"))
    parser.add_argument("--verbose", action="store_true")
    args = parser.parse_args()

    rows, problems = load_rows(args.contract)
    if not rows and not problems:
        # 合同表被误清空或只剩注释时，零次请求不能算通过。
        problems.append(f"{args.contract.name} 里一行用例都没有")
    if problems:
        for problem in problems:
            print(f"contract: {problem}", file=sys.stderr)
        return 2

    target = Target(args)
    counts = {"pass": 0, "fail": 0, "skip": 0}
    consecutive_request_errors = 0
    stopped_early = False
    for index, row in enumerate(rows):
        try:
            verdict, notes = check_row(target, row)
        except REQUEST_ERRORS as error:
            verdict, notes = "fail", [f"请求失败：{type(error).__name__}: {error}"]
            consecutive_request_errors += 1
        except (ValueError, KeyError) as error:
            verdict, notes = "fail", [f"无法核对：{type(error).__name__}: {error}"]
            consecutive_request_errors = 0
        else:
            # 跳过的行没有发出请求，既不算失败，也不能证明站点还能连上。
            if verdict != "skip":
                consecutive_request_errors = 0
        counts[verdict] += 1
        where = f"{args.contract.name}:{row.line_no}"
        if verdict == "fail":
            print(f"不通过 {where}: {describe(row)}")
            for note in notes:
                print(f"    {note}")
        elif verdict == "skip" or args.verbose:
            label = "跳过" if verdict == "skip" else "通过"
            print(f"{label} {where}: {describe(row)}" + (f"（{'；'.join(notes)}）" if notes else ""))
        if consecutive_request_errors >= MAX_CONSECUTIVE_REQUEST_ERRORS:
            remaining = len(rows) - index - 1
            print(f"连续 {consecutive_request_errors} 行请求失败（连接错误或超时），停止检查；还有 {remaining} 行没有跑")
            stopped_early = True
            break

    total = len(rows)
    print(f"合同：共 {total} 行，通过 {counts['pass']}，跳过 {counts['skip']}，不通过 {counts['fail']}；对 {target.description}")
    return 1 if counts["fail"] or stopped_early else 0


if __name__ == "__main__":
    sys.exit(main())
