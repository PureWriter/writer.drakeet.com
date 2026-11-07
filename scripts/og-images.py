#!/usr/bin/env python3
"""生成各语言的分享卡片大图（OpenGraph 与 Twitter 的 summary_large_image），1200×630，写到 assets/img/og/。

用法（需要 Pillow；本机系统的 Python 没有时，在临时虚拟环境里装上再运行）：
  python3 scripts/og-images.py [--ios-repo /Users/drakeet/Documents/iOS/writer]

底图取自 iOS 仓库 store-assets/header/<语言>.png，即 App Store 产品页的页头：「雾山」稿纸加「写作，连接过去，遥想未来。」，
3840×1646，由那边的 scripts/store-screenshots/header.py 生成。页头刻意不写 App 名称（商店页上名称另有位置），分享卡片
却常常脱离页面单独出现，所以左上角补上图标与名称，其余沿用页头的画面与排版，不另起一套视觉。

取景：从页头截取 2400×1260（正好是 1200×630 的两倍），水平居中；竖直方向从第 200 行起，文字上方留出放名称的天空，
下方保留层叠的山峦，页头最底下 186 行的山脚舍去。名称的颜色与页头标题相同（近黑 #1E1D1A），字体也相同：
中日文用思源黑体对应地区的版本，英文用 Albert Sans，字体须先装进 ~/Library/Fonts（见 iOS 仓库的
scripts/store-screenshots/README.md）。

产物是 JPEG（照片底图，质量 88），文件名用站点的语言键；港繁与台繁的页头文字相同，共用 zh-hant 一张。改了页头或本脚本
重新生成后，提交 assets/img/og/ 下的产物。
站点构建时给它们加内容指纹、原样发布为 JPEG（不转 WebP：不少平台抓取分享图时不认 WebP），见 layouts/partials/head.html。
"""
import argparse
import os

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..'))
FONTS = os.path.expanduser('~/Library/Fonts')
ICON = os.path.join(REPO, 'static', 'images', 'icon512.png')
OUTPUT = os.path.join(REPO, 'assets', 'img', 'og')

SIZE = (1200, 630)
CROP = (720, 200, 720 + 2400, 200 + 1260)
TITLE_COLOR = (30, 29, 26)

ICON_SIZE = 72
MARGIN = 48
ICON_TEXT_GAP = 18
NAME_SIZE = 34

# 站点语言键 → 页头文件名、名称、名称的字体。
LANGUAGES = {
    'zh-hans': dict(header='zh-Hans', name='纯纯写作', font='NotoSansSC-Bold.otf'),
    'zh-hant': dict(header='zh-Hant', name='純純寫作', font='NotoSansTC-Bold.otf'),
    'en': dict(header='en-US', name='Pure Writer', font='AlbertSans-SemiBold.ttf'),
    'ja': dict(header='ja', name='純純執筆', font='NotoSansJP-Bold.otf'),
}


def render(header_path, name, font_path):
    image = Image.open(header_path).convert('RGB').crop(CROP).resize(SIZE, Image.LANCZOS)

    # 图标按 4 倍缩小后贴上，保留它自带的透明圆角。
    icon = Image.open(ICON).convert('RGBA').resize((ICON_SIZE, ICON_SIZE), Image.LANCZOS)
    image.paste(icon, (MARGIN, MARGIN), icon)

    # 名称按墨迹与图标竖直居中：不同字体的上下留白不同，按字框居中会忽高忽低。
    font = ImageFont.truetype(font_path, NAME_SIZE)
    draw = ImageDraw.Draw(image)
    left, top, right, bottom = draw.textbbox((0, 0), name, font=font)
    x = MARGIN + ICON_SIZE + ICON_TEXT_GAP - left
    y = MARGIN + (ICON_SIZE - (bottom - top)) / 2 - top
    draw.text((x, y), name, font=font, fill=TITLE_COLOR)
    return image


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--ios-repo', default='/Users/drakeet/Documents/iOS/writer')
    args = parser.parse_args()

    os.makedirs(OUTPUT, exist_ok=True)
    for key, spec in LANGUAGES.items():
        header_path = os.path.join(args.ios_repo, 'store-assets', 'header', spec['header'] + '.png')
        image = render(header_path, spec['name'], os.path.join(FONTS, spec['font']))
        out = os.path.join(OUTPUT, key + '.jpg')
        image.save(out, 'JPEG', quality=88, optimize=True, progressive=True)
        print(f'{out}  {os.path.getsize(out) // 1024} KB')


if __name__ == '__main__':
    main()
