#!/usr/bin/env python3
"""比对旧页与新页的正文（docs/rebuild.md 第九节 B 的「逐页文本比对」），只用 Python 标准库。

  python3 -I scripts/compare-text.py <旧页.html> <新页.html> [选项]

  --old-select 选择器   旧页里要比对的区域，默认：有 #write（Typora 导出页）就取它，否则取 body
  --new-select 选择器   新页里要比对的区域，默认 main
  --skip 标签名或 .类名  两边都跳过的元素（可以重复），例如 --skip footer、--skip .note
  --ids                 另外列出旧页里有、新页里没有的锚点（id 与 a name）

选择器只支持几种简单写法：tag、#id、.class、tag[attr=value]、tag.class。

做法：去掉标记，块级元素与 <br> 各自成行，行内连续的半角空白合并成一个空格，然后逐行做 diff。两边一致时退出码为 0，
否则为 1 并打印差异。几条细则：
  - 全角空格（U+3000）照常比对，中文段首的「　　」少了或多了都会报出来；
  - 代码块逐行比对，块内的空行也算一行，行尾的半角空白不计；
  - 旧站 Typora 导出页（body 带 typora-export）的段落是 white-space: pre-wrap，段内的字面换行在页面上显示为换行，
    这里也按换行算：新页用 <br>（Markdown 行尾的 \\）保住换行才算一致，写成软换行会报出来；
  - Typora 的代码块是 CodeMirror 渲染的：每行一个 pre.CodeMirror-line，另有隐藏的测量元素 .CodeMirror-measure
    （内容是 xxxxxxxxxx）、为显示连续空格插入的不换行空格、零宽空格，以及把不可见字符画成红点「•」的 .cm-invalidchar。
    这里跳过测量元素与红点，把不换行空格当作普通空格、去掉零宽空格，还原成原文再比。
工具只比文字：链接地址、加粗与行内代码的范围不在比对范围内，复核时另外核对。
"""

import argparse
import difflib
import html.parser
import re
import sys

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"}
SKIP_ALWAYS = {"script", "style", "svg", "noscript", "template", "head", "textarea"}
# CodeMirror 的隐藏测量元素，以及它把零宽空格等不可见字符画成的红点占位「•」（原文里是看不见的字符）。
SKIP_CLASSES_ALWAYS = {"CodeMirror-measure", "cm-invalidchar"}
BLOCK = {
    "address", "article", "aside", "blockquote", "body", "dd", "details", "dialog", "div", "dl", "dt", "fieldset",
    "figcaption", "figure", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6", "header", "hr", "li", "main", "nav",
    "ol", "p", "pre", "section", "summary", "table", "tbody", "td", "tfoot", "th", "thead", "tr", "ul", "br", "html",
}
# 合并的只是半角空白与不换行空格；全角空格不在其中。
SPACES = re.compile(r"[ \t\n\r\f\v\u00a0]+")
ZERO_WIDTH = "\u200b"


class Node:
    def __init__(self, tag, attrs, parent):
        self.tag = tag
        self.attrs = dict(attrs)
        self.parent = parent
        self.children = []

    def classes(self):
        return set((self.attrs.get("class") or "").split())


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
    if cls and cls not in node.classes():
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


def node_text(node):
    parts = []
    for child in node.children:
        if isinstance(child, str):
            parts.append(child)
        elif child.tag not in SKIP_ALWAYS and not (child.classes() & SKIP_CLASSES_ALWAYS):
            parts.append(node_text(child))
    return "".join(parts)


def code_line(text):
    """代码行还原成原文：去掉零宽空格，不换行空格当作普通空格，行尾的半角空白不计（全角空格保留）。"""
    return text.replace(ZERO_WIDTH, "").replace("\u00a0", " ").rstrip(" \t\n\r\f\v")


def text_lines(node, skip_tags, skip_classes, pre_wrap):
    """把一个区域变成文本行。pre_wrap 为真时，段落里的字面换行按换行算（旧站 Typora 导出页）。"""
    lines = []
    buffer = []

    def flush():
        # 只去掉两端的半角空格；U+3000 不动，中文段首的「　　」照常参与比对。
        text = SPACES.sub(" ", "".join(buffer).replace(ZERO_WIDTH, "")).strip(" ")
        if text:
            lines.append(text)
        buffer.clear()

    def add_pre_block(text):
        # 新站的 <pre><code>：按换行切开，保留块内的空行，去掉首尾的空行（Hugo 在 </code> 前补的换行）。
        block = [code_line(part) for part in text.split("\n")]
        while block and not block[0]:
            block.pop(0)
        while block and not block[-1]:
            block.pop()
        lines.extend(block)

    def walk(current):
        for child in current.children:
            if isinstance(child, str):
                if pre_wrap and "\n" in child:
                    parts = child.split("\n")
                    for index, part in enumerate(parts):
                        if index:
                            flush()
                        buffer.append(part)
                else:
                    buffer.append(child)
                continue
            classes = child.classes()
            if child.tag in SKIP_ALWAYS or child.tag in skip_tags or classes & (SKIP_CLASSES_ALWAYS | skip_classes):
                continue
            if "CodeMirror-line" in classes:
                # Typora 代码块的一行：空行也是一行。
                flush()
                lines.append(code_line(node_text(child)))
                continue
            if child.tag == "pre" and "md-fences" not in classes:
                flush()
                add_pre_block(node_text(child))
                continue
            block = child.tag in BLOCK
            if block:
                flush()
            walk(child)
            if block:
                flush()

    walk(node)
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

    skip_tags = {item for item in args.skip if not item.startswith(".")}
    skip_classes = {item[1:] for item in args.skip if item.startswith(".")}
    old_body = find(old_doc.root, "body")
    old_pre_wrap = old_body is not None and "typora-export" in old_body.classes()
    old_lines = text_lines(old_area, skip_tags, skip_classes, old_pre_wrap)
    new_lines = text_lines(new_area, skip_tags, skip_classes, False)
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
