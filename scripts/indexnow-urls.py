#!/usr/bin/env python3
"""列出要推送给 IndexNow 的地址（docs/rebuild.md 第九节 E），只用 Python 标准库。

scripts/deploy.sh 经 ssh 把本脚本从标准输入交给服务器上的 python3 运行，不必另外安装到服务器上：
  正式站部署成功后，只列内容有变化的页面：
    python3 -I - --site writer.drakeet.com <新版本>/public <切换前的版本>/public
  手动推送（scripts/deploy.sh --indexnow-only），列出全部页面：
    python3 -I - --site writer.drakeet.com <当前版本>/public

每行输出一个地址，顺序与 sitemap 相同。只看 sitemap 里的页面：sitemap 模板不列带 noindex 的页面（4.10），列在里面就是应当
收录的。给了上一版时，逐个逐字节比较两个版本里同一地址对应的页面文件，只输出内容不同、或上一版没有的；上一版的目录不存在时
（首次部署时没有可比较的版本）每个页面都算新增，输出全部。CSS 的内容指纹一变，所有页面的 HTML 都跟着变，这时全推是对的。
sitemap 里的地址在新版本里找不到对应的文件时以 1 退出，不输出任何地址：那是构建出了问题，推送一份残缺的名单没有意义。
"""

import argparse
import filecmp
import pathlib
import sys
import urllib.parse
from xml.etree import ElementTree

SITEMAP_NS = "{http://www.sitemaps.org/schemas/sitemap/0.9}"


def page_file(public, origin, url):
    """sitemap 里的地址在产物里对应的文件：https://writer.drakeet.com/en/manual/ 是 <public>/en/manual/index.html。"""
    if not url.startswith(origin + "/"):
        sys.exit(f"indexnow-urls: sitemap 里的地址不属于 {origin}：{url}")
    path = urllib.parse.unquote(urllib.parse.urlsplit(url).path)
    file = public / path.lstrip("/")
    if path.endswith("/"):
        file = file / "index.html"
    return file


def sitemap_urls(public, origin):
    """新版本 sitemap 里的全部地址。根目录的 sitemap.xml 是 Hugo 生成的索引，各语言一份 urlset；只有一种语言时它本身就是 urlset。"""
    root = ElementTree.parse(public / "sitemap.xml").getroot()
    if root.tag == SITEMAP_NS + "sitemapindex":
        urlsets = [
            ElementTree.parse(page_file(public, origin, loc.text.strip())).getroot()
            for loc in root.iterfind(f"{SITEMAP_NS}sitemap/{SITEMAP_NS}loc")
        ]
    else:
        urlsets = [root]
    urls = []
    for urlset in urlsets:
        for loc in urlset.iterfind(f"{SITEMAP_NS}url/{SITEMAP_NS}loc"):
            url = loc.text.strip()
            if url not in urls:
                urls.append(url)
    return urls


def main():
    parser = argparse.ArgumentParser(prog="indexnow-urls.py", description="列出要推送给 IndexNow 的地址")
    parser.add_argument("--site", required=True, help="正式站的主机名，sitemap 里的地址都以 https://<主机名>/ 开头")
    parser.add_argument("new", type=pathlib.Path, help="新版本（或当前版本）的 public 目录")
    parser.add_argument("old", type=pathlib.Path, nargs="?", help="切换前那一版的 public 目录；不给就列出全部页面")
    args = parser.parse_args()

    origin = f"https://{args.site}"
    urls = sitemap_urls(args.new, origin)
    if not urls:
        sys.exit("indexnow-urls: sitemap 里一个地址都没有")
    selected = []
    for url in urls:
        new_file = page_file(args.new, origin, url)
        if not new_file.is_file():
            sys.exit(f"indexnow-urls: sitemap 里的 {url} 在产物里没有对应的文件 {new_file}")
        if args.old is not None:
            old_file = page_file(args.old, origin, url)
            # shallow=False：一律逐字节比较内容，不因大小与修改时间相同就认定没变。
            if old_file.is_file() and filecmp.cmp(new_file, old_file, shallow=False):
                continue
        selected.append(url)
    for url in selected:
        print(url)


if __name__ == "__main__":
    main()
