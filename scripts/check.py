#!/usr/bin/env python3
"""构建产物的检查（docs/rebuild.md 第六节），由 scripts/build.sh 调用，只用 Python 标准库。

  python3 scripts/check.py <产物目录> --expected ops/expected-files.txt [--update-expected]

检查两项，任何一项不通过就以非零状态退出：
  1. 期望产物清单：产物目录里的文件（不含预压缩的 .br、.gz）与入库的清单逐行比对，多一个、少一个都报错。这样新站的
     地址空间严格等于约定，Hugo 自作主张多生成的页面也能当场暴露。有意增删页面时，用 --update-expected 重写清单。
  2. 站内链接与锚点：每个 HTML 里指向本站的 href、src 都必须能落到产物里的文件；带 #锚点 的，目标页面里必须有
     同名的 id。站内链接一律写新地址，旧地址只给站外的存量链接用，所以指向旧地址也算错。
"""

import argparse
import html.parser
import pathlib
import re
import sys
import urllib.parse

SITE_ORIGIN = "https://writer.drakeet.com"

# 不在产物里、由服务器处理的站内地址：根地址按语言协商（caddy/site.caddy），JAR 镜像在站点目录之外（5.6）。
SERVER_PATHS = {"/"}
SERVER_PREFIXES = ("/ocat/jars/",)


class LinkCollector(html.parser.HTMLParser):
    """收集一个 HTML 文件里的 id（含旧式 a name）与指向其他资源的地址。"""

    LINK_ATTRS = {"a": ("href",), "link": ("href",), "img": ("src", "srcset"), "script": ("src",), "source": ("src", "srcset")}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = set()
        self.links = []

    def handle_starttag(self, tag, attrs):
        values = dict(attrs)
        if values.get("id"):
            self.ids.add(values["id"])
        if tag == "a" and values.get("name"):
            self.ids.add(values["name"])
        # canonical、hreflang、og 一类指向自身的绝对地址不算站内导航，交给 Hugo 生成，这里不查。
        if tag == "link" and values.get("rel") not in ("stylesheet", "icon", "apple-touch-icon"):
            return
        for attr in self.LINK_ATTRS.get(tag, ()):
            value = values.get(attr)
            if not value:
                continue
            if attr == "srcset":
                for candidate in value.split(","):
                    url = candidate.strip().split(" ")[0]
                    if url:
                        self.links.append(url)
            else:
                self.links.append(value)


# Hugo 给样式、脚本加上 64 位十六进制的内容指纹，给处理过的图片加上 _hu_ 与一段哈希；清单里分别写成 <fingerprint>
# 与 _hu_<hash>，内容一改哈希就变，不必每次都重写清单。
FINGERPRINT = re.compile(r"\.[0-9a-f]{64}(?=\.[a-z0-9]+$)")
PROCESSED_IMAGE = re.compile(r"_hu_[0-9a-f]+(?=\.[a-z0-9]+$)")


def normalize(path):
    return PROCESSED_IMAGE.sub("_hu_<hash>", FINGERPRINT.sub(".<fingerprint>", path))


def list_files(root):
    return sorted(
        normalize(path.relative_to(root).as_posix())
        for path in root.rglob("*")
        if path.is_file() and path.suffix not in (".br", ".gz")
    )


def check_expected(root, expected_path, update):
    actual = list_files(root)
    if update:
        header = (
            "# 期望产物清单：scripts/build.sh 的产物（不含预压缩的 .br、.gz）必须与这份清单完全一致。\n"
            "# 有意增删页面或静态文件时，运行 scripts/build.sh --worktree --update-expected 重写，并在提交里说明原因。\n"
        )
        expected_path.write_text(header + "\n".join(actual) + "\n")
        print(f"check: 已重写 {expected_path}（{len(actual)} 个文件）")
        return []
    if not expected_path.exists():
        print(f"check: 没有 {expected_path}，跳过期望产物清单的比对", file=sys.stderr)
        return []
    expected = [
        line.strip()
        for line in expected_path.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]
    problems = []
    for path in sorted(set(actual) - set(expected)):
        problems.append(f"多出的产物（不在 {expected_path.name} 里）：{path}")
    for path in sorted(set(expected) - set(actual)):
        problems.append(f"缺少的产物（{expected_path.name} 里有）：{path}")
    return problems


def resolve(root, page_path, url):
    """把一个站内地址解析成产物里的文件，返回 (文件或 None, 锚点)；站外地址与服务器处理的地址返回 (False, None)。"""
    parsed = urllib.parse.urlsplit(url)
    if parsed.scheme in ("mailto", "tel", "data", "javascript"):
        return False, None
    if parsed.scheme or parsed.netloc:
        if f"{parsed.scheme}://{parsed.netloc}" != SITE_ORIGIN:
            return False, None
    path = urllib.parse.unquote(parsed.path)
    fragment = urllib.parse.unquote(parsed.fragment)
    if not path:
        return page_path, fragment
    if not path.startswith("/"):
        # 相对地址按页面自己的地址解析，例如 /zh-hans/desktop/index.html 里的 ../manual/ 是 /zh-hans/manual/。
        page_url = "/" + page_path.relative_to(root).as_posix()
        path = urllib.parse.urljoin(page_url, path)
    if path in SERVER_PATHS or path.startswith(SERVER_PREFIXES):
        return False, None
    target = root / path.lstrip("/")
    if path.endswith("/"):
        target = target / "index.html"
    elif target.is_dir():
        target = target / "index.html"
    return (target if target.is_file() else None), fragment


def check_links(root):
    pages = {}
    for page in root.rglob("*.html"):
        collector = LinkCollector()
        collector.feed(page.read_text(encoding="utf-8"))
        pages[page] = collector
    problems = []
    for page, collector in sorted(pages.items()):
        where = "/" + str(page.relative_to(root))
        for url in collector.links:
            target, fragment = resolve(root, page, url)
            if target is False:
                continue
            if target is None:
                problems.append(f"{where}：站内链接落不到产物里的文件：{url}")
                continue
            if fragment and target.suffix == ".html":
                ids = pages[target].ids if target in pages else set()
                if fragment not in ids:
                    problems.append(f"{where}：锚点在目标页面里不存在：{url}")
    return problems


def main():
    parser = argparse.ArgumentParser(description="检查构建产物")
    parser.add_argument("root", type=pathlib.Path)
    parser.add_argument("--expected", type=pathlib.Path, required=True)
    parser.add_argument("--update-expected", action="store_true")
    args = parser.parse_args()

    root = args.root.resolve()
    problems = check_links(root)
    if not problems:
        problems += check_expected(root, args.expected, args.update_expected)
    if problems:
        for problem in problems:
            print(f"check: {problem}", file=sys.stderr)
        print(f"check: 共 {len(problems)} 个问题", file=sys.stderr)
        return 1
    print("check: 站内链接、锚点与期望产物清单都通过")
    return 0


if __name__ == "__main__":
    sys.exit(main())
