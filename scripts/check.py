#!/usr/bin/env python3
"""构建产物的检查（docs/rebuild.md 第六节），由 scripts/build.sh 调用，只用 Python 标准库。

  python3 scripts/check.py <产物目录> --expected ops/expected-files.txt --market ops/market-rules.toml \
      --zh-variants ops/zh-variants.toml [--images ops/images.sha256] [--update-expected]

检查八项，任何一项不通过就以非零状态退出：
  1. 期望产物清单：产物目录里的所有文件与入库的清单逐行比对，多一个、少一个都报错，清单文件不存在也报错。这样新站的
     地址空间严格等于约定，Hugo 自作主张多生成的页面也能当场暴露。有意增删页面时，用 --update-expected 重写清单。
  2. 站内链接与锚点：每个 HTML 里指向本站的 href、src 都必须能落到产物里的文件；带 #锚点 的，目标页面里必须有
     同名的 id。站内链接一律写新地址，旧地址只给站外的存量链接用，所以指向旧地址也算错。
  3. 市场差异：只适合中国大陆用户的内容（备案号、蓝奏云、国内下载、360、坚果云与网盘切换截图）不得出现在简体中文以外
     的产物里。规则与豁免写在 ops/market-rules.toml；「旧版」名单里的页面只提示、不拦截。
  4. 台港用词：繁体（台湾）页面不得出现香港用词，繁体（香港）页面不得出现台湾用词，词表在 ops/zh-variants.toml。
     只查文字，不查沿用旧站的锚点 id。
  5. iOS 隐私政策各语言的「更新日期」「生效日期」一致（旧站五种语言同页时天然同步，拆成五个文件后靠这项检查）。
  6. 固定图片的原字节：/images/ 下的每个文件按入库的 sha256 清单（ops/images.sha256）核对，多、少、字节不同都报错。
  7. Apple 关联域名文件 /.well-known/apple-app-site-association 是合法的 JSON，webcredentials.apps 里有本 App。
  8. 本机运行的 bash 脚本（本脚本所在的 scripts/ 目录）里，`$名字` 后面不得紧跟中文等非 ASCII 字符：macOS 自带的
     /bin/bash 3.2 在 UTF-8 环境下会把那个字符的首字节当成变量名的一部分，set -u 时报 unbound variable 退出（Drakeet 的
     终端就是 UTF-8，桌面版 release.sh 也在那里调用 deploy.sh），要写成 `${名字}`。ops/bin/ 在服务器的 bash 5 上运行，不查。
第 3、4 项跳过下载页里来自桌面端更新日志的条目（data-source="desktop.json"）：那段文字的用词归桌面端管，
不能让官网的检查拦住桌面版发版（rebuild.md 第一节「取舍原则」）。

本脚本在 build.sh 第 5 步运行，那时还没有预压缩（第 6 步），所以第 1、6 项不为 .br、.gz 留任何例外：产物里出现的 .br、.gz
只可能来自源文件，Caddy 的 precompressed 会把它当成原文件的副本发给浏览器，内容却没有经过任何核对。它照常被报成多出的
产物，/images/ 下的报成不在清单里。
"""

import argparse
import fnmatch
import hashlib
import html.parser
import json
import pathlib
import re
import sys
import tomllib
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
    # 收入所有文件，.br、.gz 也不例外（理由见文件开头）。
    return sorted(
        normalize(path.relative_to(root).as_posix())
        for path in root.rglob("*")
        if path.is_file()
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
    # 清单丢了不能当作通过：那样地址空间就没有约束了，多出的页面与文件都发现不了。
    if not expected_path.is_file():
        return [f"找不到期望产物清单 {expected_path}；有意重建清单时用 --update-expected"]
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


# 市场检查不看的产物：简体中文页面本身、旧图片、.well-known、发版数据（含各语言的更新日志）。
MARKET_SKIP_PREFIXES = ("/zh-hans/", "/images/", "/.well-known/")
MARKET_SKIP_FILES = {"/desktop.json", "/desktop2.json"}
MARKET_SUFFIXES = {".html", ".txt", ".xml", ".json"}


# 下载页里来自桌面端更新日志的条目（notes shortcode 输出），市场与台港用词检查跳过它。产物经过压缩，属性可能不带引号。
EXTERNAL_TEXT = re.compile(r"<ul[^>]*\bdata-source=[\"']?desktop\.json[\"']?[^>]*>.*?</ul>", re.S)


def page_text(file):
    return EXTERNAL_TEXT.sub("", file.read_text(encoding="utf-8"))


def page_path(root, file):
    """产物里的文件对应的地址路径：/en/manual/index.html 记作 /en/manual/，便于与豁免前缀比较。"""
    path = "/" + file.relative_to(root).as_posix()
    return path[: -len("index.html")] if path.endswith("/index.html") else path


def exempted(path, patterns):
    return any(fnmatch.fnmatchcase(path, pattern + "*") for pattern in patterns)


def check_market(root, rules_path):
    rules = tomllib.loads(rules_path.read_text(encoding="utf-8"))
    groups = [(group["name"], re.compile(group["pattern"], re.IGNORECASE), group.get("exempt", [])) for group in rules["group"]]
    warn_only = rules.get("legacy_warn_only", [])
    problems, warnings = [], []
    for file in sorted(root.rglob("*")):
        if not file.is_file() or file.suffix not in MARKET_SUFFIXES:
            continue
        path = page_path(root, file)
        if path.startswith(MARKET_SKIP_PREFIXES) or path in MARKET_SKIP_FILES:
            continue
        text = page_text(file)
        for name, pattern, exempt in groups:
            if exempted(path, exempt):
                continue
            hits = sorted({match.group(0) for match in pattern.finditer(text)})
            if not hits:
                continue
            message = f"{path}：出现了只适合中国大陆的内容（{name}）：{'、'.join(hits)}"
            (warnings if exempted(path, warn_only) else problems).append(message)
    return problems, warnings


# 台港用词只查读者看得到的文字，不查锚点的 id：页面改写后仍保留旧站的锚点 id，站外的旧链接才能落到原来那一条，
# 而旧 id 来自旧标题，带着当年的用词（例如繁体手册的「實時」「代碼」）。href 里的中文是百分号编码，本来就不会命中。
# 产物经过压缩，属性值可能不带引号。
ID_ATTRIBUTE = re.compile(r"""\sid=(?:"[^"]*"|'[^']*'|[^\s>]+)""")


def check_zh_variants(root, rules_path):
    rules = tomllib.loads(rules_path.read_text(encoding="utf-8"))
    warn_only = rules.get("legacy_warn_only", [])
    # 台湾页面查香港用词，香港页面查台湾用词。
    banned = {"/zh-hant/": ("香港", rules["hk"]), "/zh-hk/": ("台湾", rules["tw"])}
    problems, warnings = [], []
    for file in sorted(root.rglob("*.html")):
        path = page_path(root, file)
        for prefix, (region, words) in banned.items():
            if not path.startswith(prefix):
                continue
            text = ID_ATTRIBUTE.sub("", page_text(file))
            hits = [word for word in words if word in text]
            if hits:
                message = f"{path}：出现了{region}用词：{'、'.join(hits)}"
                (warnings if exempted(path, warn_only) else problems).append(message)
    return problems, warnings


PRIVACY_LANGUAGES = ("zh-hans", "zh-hant", "zh-hk", "en", "ja")
META_PARAGRAPH = re.compile(r"<p[^>]*\bclass=[\"']?meta[\"']?[^>]*>(.*?)</p>", re.S)
CJK_DATE = re.compile(r"(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日")
MONTHS = ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
EN_DATE = re.compile(r"(" + "|".join(MONTHS) + r")\s+(\d{1,2}),\s*(\d{4})")


def privacy_dates(file):
    """取 iOS 隐私政策日期段里的日期，按出现顺序返回 [(年, 月, 日), …]：先是更新日期，后是生效日期。"""
    match = META_PARAGRAPH.search(file.read_text(encoding="utf-8"))
    if not match:
        return None
    text = match.group(1)
    dates = [(int(y), int(m), int(d)) for y, m, d in CJK_DATE.findall(text)]
    dates += [(int(y), MONTHS.index(month) + 1, int(d)) for month, d, y in EN_DATE.findall(text)]
    return dates


def check_privacy_dates(root):
    found = {}
    for language in PRIVACY_LANGUAGES:
        file = root / language / "ios" / "privacy" / "index.html"
        if not file.is_file():
            return [f"/{language}/ios/privacy/ 不存在"]
        dates = privacy_dates(file)
        if not dates:
            return [f"/{language}/ios/privacy/：找不到 class=meta 的日期段，或其中没有可识别的日期"]
        found[language] = dates
    if len({tuple(dates) for dates in found.values()}) == 1:
        return []
    detail = "；".join(f"{language} {dates}" for language, dates in found.items())
    return [f"iOS 隐私政策各语言的日期不一致：{detail}"]


# 固定图片（第三节、4.8）。清单里的路径相对于产物根目录，例如 images/papers/0.jpg。
IMAGES_REASON = (
    "/images/ 下是旧站图片，必须按原路径、原字节发布：Android 稿纸背景把完整地址存进用户设置，ocat.app 曾热链其中 5 张，"
    "社交平台的旧分享预览也在引用，不允许重新压缩、替换或改名（docs/rebuild.md 第三节、4.8）"
)
SHA256_LINE = re.compile(r"([0-9a-f]{64})  (images/\S.*)")


def check_images(root, manifest_path):
    if not manifest_path.is_file():
        return [f"找不到固定图片的清单 {manifest_path}"]
    expected = {}
    problems = []
    for line_no, line in enumerate(manifest_path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip() or line.startswith("#"):
            continue
        match = SHA256_LINE.fullmatch(line)
        if not match:
            problems.append(f"{manifest_path.name}:{line_no}：应写成「sha256  images/…」：{line}")
            continue
        expected[match.group(2)] = match.group(1)

    actual = {}
    for file in sorted((root / "images").rglob("*")):
        if not file.is_file():
            continue
        actual[file.relative_to(root).as_posix()] = hashlib.sha256(file.read_bytes()).hexdigest()

    for path in sorted(actual.keys() - expected.keys()):
        problems.append(f"/{path} 不在 {manifest_path.name} 里：/images/ 只放旧站原有的图片，新页面的图片放进 assets/（4.8）")
    for path in sorted(expected.keys() - actual.keys()):
        problems.append(f"缺少 /{path}（{manifest_path.name} 里有）：{IMAGES_REASON}")
    for path in sorted(expected.keys() & actual.keys()):
        if actual[path] != expected[path]:
            problems.append(f"/{path} 的字节与 {manifest_path.name} 不同：{IMAGES_REASON}")
    return problems


# Apple 关联域名文件（第三节）：iOS 1.0 起各版都写死了 webcredentials 关联域名，Apple 的 CDN 抓到无效的文件，密码自动填充
# 就失效。合同只能核对状态码、类型与片段，证明不了它是合法的 JSON，所以在构建时解析一遍。
AASA_PATH = ".well-known/apple-app-site-association"
AASA_APP_ID = "9MKUN97L6J.com.drakeet.writer"


def reject_constant(name):
    """json.loads 默认接受 NaN、Infinity、-Infinity，它们不是合法的 JSON（RFC 8259），遇到就报错。"""
    raise ValueError(f"含有非标准的常量 {name}")


def check_aasa(root):
    file = root / AASA_PATH
    if not file.is_file():
        return [f"缺少 /{AASA_PATH}"]
    try:
        data = json.loads(file.read_text(encoding="utf-8"), parse_constant=reject_constant)
    except ValueError as error:
        # JSONDecodeError、UnicodeDecodeError 与 reject_constant 抛出的都是 ValueError。
        return [f"/{AASA_PATH} 不是合法的 JSON：{error}"]
    webcredentials = data.get("webcredentials") if isinstance(data, dict) else None
    apps = webcredentials.get("apps") if isinstance(webcredentials, dict) else None
    if not isinstance(apps, list) or AASA_APP_ID not in apps:
        return [f"/{AASA_PATH} 的 webcredentials.apps 里没有 {AASA_APP_ID}"]
    return []


# 第 8 项：$名字 紧跟一个非 ASCII 字符（前面不是反斜杠转义）。
SHELL_VARIABLE_BEFORE_NON_ASCII = re.compile(r"(?<!\\)\$[A-Za-z_][A-Za-z0-9_]*(?=[^\x00-\x7f])")


def check_shell_scripts(scripts_dir):
    problems = []
    for file in sorted(scripts_dir.iterdir()):
        if not file.is_file():
            continue
        try:
            text = file.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        first_line = text.split("\n", 1)[0]
        if not (first_line.startswith("#!") and "bash" in first_line):
            continue
        for number, line in enumerate(text.splitlines(), 1):
            # 注释里的写法不影响运行。
            if line.lstrip().startswith("#"):
                continue
            if SHELL_VARIABLE_BEFORE_NON_ASCII.search(line):
                problems.append(
                    f"scripts/{file.name} 第 {number} 行：变量后面紧跟非 ASCII 字符，macOS 的 bash 3.2 在 UTF-8 环境下会报"
                    f" unbound variable，写成 ${{名字}}"
                )
    return problems


def main():
    parser = argparse.ArgumentParser(description="检查构建产物")
    parser.add_argument("root", type=pathlib.Path)
    parser.add_argument("--expected", type=pathlib.Path, required=True)
    parser.add_argument("--market", type=pathlib.Path, required=True)
    parser.add_argument("--zh-variants", type=pathlib.Path, required=True)
    # 默认取与本脚本同一份检出里的清单，直接运行本脚本时不必写。
    parser.add_argument(
        "--images", type=pathlib.Path, default=pathlib.Path(__file__).resolve().parent.parent / "ops" / "images.sha256"
    )
    parser.add_argument("--update-expected", action="store_true")
    args = parser.parse_args()

    root = args.root.resolve()
    problems = check_links(root)
    market_problems, market_warnings = check_market(root, args.market)
    variant_problems, variant_warnings = check_zh_variants(root, args.zh_variants)
    problems += market_problems + variant_problems + check_privacy_dates(root)
    problems += check_images(root, args.images) + check_aasa(root)
    problems += check_shell_scripts(pathlib.Path(__file__).resolve().parent)
    for warning in market_warnings + variant_warnings:
        print(f"check: 提示（旧版名单，不拦截）：{warning}", file=sys.stderr)
    if not problems:
        problems += check_expected(root, args.expected, args.update_expected)
    if problems:
        for problem in problems:
            print(f"check: {problem}", file=sys.stderr)
        print(f"check: 共 {len(problems)} 个问题", file=sys.stderr)
        return 1
    print("check: 站内链接、锚点、市场差异、台港用词、iOS 隐私政策日期、固定图片的原字节、Apple 关联域名文件、本机脚本的 bash 3.2 兼容与期望产物清单都通过")
    return 0


if __name__ == "__main__":
    sys.exit(main())
