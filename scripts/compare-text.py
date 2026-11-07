#!/usr/bin/env python3
"""比对旧页与新页的正文（docs/rebuild.md 第九节 B 的「逐页文本比对」），只用 Python 标准库。

  python3 -I scripts/compare-text.py <旧页.html> <新页.html> [选项]

  --old-select 选择器   旧页里要比对的区域，默认：有 #write（Typora 导出页）就取它，否则取 body
  --new-select 选择器   新页里要比对的区域，默认 main
  --skip 标签名         两边都跳过的元素（可以重复），例如 --skip footer
  --ids                 另外列出旧页里有、新页里没有的锚点（id 与 a name）

选择器只支持几种简单写法：tag、#id、.class、tag[attr=value]、tag.class。

做法：去掉标记，块级元素各自成行，行内连续的半角空白合并成一个空格（全角空格保留，中文段首的「　　」照常比对），
<pre> 里的换行原样保留；然后逐行做 diff。两边一致时退出码为 0，否则为 1 并打印差异。
"""

import argparse
import difflib
import html.parser
import re
import sys

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"}
SKIP_ALWAYS = {"script", "style", "svg", "noscript", "template", "head"}
BLOCK = {
    "address", "article", "aside", "blockquote", "body", "dd", "details", "dialog", "div", "dl", "dt", "fieldset",
    "figcaption", "figure", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6", "header", "hr", "li", "main", "nav",
    "ol", "p", "pre", "section", "summary", "table", "tbody", "td", "tfoot", "th", "thead", "tr", "ul", "br", "html",
}
SPACES = re.compile(r"[ \t\n\r\f\v ]+")


class Node:
    def __init__(self, tag, attrs, parent):
        self.tag = tag
        self.attrs = dict(attrs)
        self.parent = parent
        self.children = []


class TreeBuilder(html.parser.HTMLParser):
    """宽松地把 HTML 建成树：只为取文本与选区域，不追求完整的 HTML5 解析规则。"""

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.root = Node("#root", [], None)
        self.current = self.root
        self.ids = set()

    def handle_starttag(self, tag, attrs):
        node = Node(tag, attrs, self.current)
        self.current.children.append(node)
        if node.attrs.get("id"):
            self.ids.add(node.attrs["id"])
        if tag == "a" and node.attrs.get("name"):
            self.ids.add(node.attrs["name"])
        if tag not in VOID:
            self.current = node

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in VOID and self.current.tag == tag:
            self.current = self.current.parent

    def handle_endtag(self, tag):
        node = self.current
        while node is not None and node.tag != tag:
            node = node.parent
        if node is not None and node.parent is not None:
            self.current = node.parent

    def handle_data(self, data):
        self.current.children.append(data)


def matches(node, selector):
    match = re.fullmatch(r"([a-z0-9]*)(?:#([\w-]+))?(?:\.([\w-]+))?(?:\[([\w-]+)=\"?([^\"\]]*)\"?\])?", selector)
    if not match:
        raise SystemExit(f"不支持的选择器：{selector}")
    tag, ident, cls, attr, value = match.groups()
    if tag and node.tag != tag:
        return False
    if ident and node.attrs.get("id") != ident:
        return False
    if cls and cls not in (node.attrs.get("class") or "").split():
        return False
    if attr and node.attrs.get(attr) != value:
        return False
    return True


def find(node, selector):
    for child in node.children:
        if isinstance(child, Node):
            if matches(child, selector):
                return child
            found = find(child, selector)
            if found is not None:
                return found
    return None


def text_lines(node, skip):
    """把一个区域变成文本行：块级元素各自成行，<pre> 保留原有换行。"""
    lines = []
    buffer = []

    def flush():
        text = SPACES.sub(" ", "".join(buffer)).strip()
        if text:
            lines.append(text)
        buffer.clear()

    def walk(current, in_pre):
        for child in current.children:
            if isinstance(child, str):
                if in_pre:
                    for index, part in enumerate(child.split("\n")):
                        if index:
                            flush_pre()
                        buffer.append(part)
                else:
                    buffer.append(child)
                continue
            if child.tag in SKIP_ALWAYS or child.tag in skip:
                continue
            block = child.tag in BLOCK
            if block:
                flush() if not in_pre else flush_pre()
            walk(child, in_pre or child.tag == "pre")
            if block:
                flush() if not in_pre else flush_pre()

    def flush_pre():
        text = "".join(buffer).rstrip()
        if text.strip():
            lines.append(text)
        buffer.clear()

    walk(node, False)
    flush()
    return lines


def subtree_ids(node):
    """一个区域里的锚点：id 与旧式 a name。"""
    ids = set()
    for child in node.children:
        if isinstance(child, Node):
            if child.attrs.get("id"):
                ids.add(child.attrs["id"])
            if child.tag == "a" and child.attrs.get("name"):
                ids.add(child.attrs["name"])
            ids |= subtree_ids(child)
    return ids


def parse(path):
    builder = TreeBuilder()
    with open(path, encoding="utf-8") as file:
        builder.feed(file.read())
    return builder


def main():
    parser = argparse.ArgumentParser(description="比对旧页与新页的正文")
    parser.add_argument("old")
    parser.add_argument("new")
    parser.add_argument("--old-select")
    parser.add_argument("--new-select", default="main")
    parser.add_argument("--skip", action="append", default=[])
    parser.add_argument("--ids", action="store_true")
    args = parser.parse_args()

    old_doc = parse(args.old)
    new_doc = parse(args.new)
    old_selector = args.old_select or ("#write" if find(old_doc.root, "#write") else "body")
    old_area = find(old_doc.root, old_selector)
    new_area = find(new_doc.root, args.new_select)
    if old_area is None:
        raise SystemExit(f"旧页里找不到 {old_selector}")
    if new_area is None:
        raise SystemExit(f"新页里找不到 {args.new_select}")

    skip = set(args.skip)
    old_lines = text_lines(old_area, skip)
    new_lines = text_lines(new_area, skip)
    status = 0
    if old_lines == new_lines:
        print(f"正文一致：{len(old_lines)} 行")
    else:
        status = 1
        ratio = difflib.SequenceMatcher(None, old_lines, new_lines).ratio()
        print(f"正文有差异（行级相似度 {ratio:.3f}）：")
        sys.stdout.writelines(
            line + "\n" for line in difflib.unified_diff(old_lines, new_lines, "旧页", "新页", n=1, lineterm="")
        )
    if args.ids:
        # 只看旧页选中区域里的锚点（排除 Typora 的 #write 一类结构性 id），在整个新页里找。
        old_ids = subtree_ids(old_area)
        missing = sorted(old_ids - new_doc.ids)
        if missing:
            status = 1
            print(f"新页缺少的锚点（{len(missing)} 个）：")
            for ident in missing:
                print(f"  #{ident}")
        else:
            print(f"锚点齐全：旧页这一区域的 {len(old_ids)} 个都在新页里")
    return status


if __name__ == "__main__":
    sys.exit(main())
