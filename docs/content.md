# 页面内容约定

写或改 `content/` 下的页面时遵守本文。站点为什么这样组织见 [rebuild.md](rebuild.md) 第四节；本文只写「怎么写」。

## 一、文件与地址

- **一个页面一个顶层目录**（扁平的叶子包），每种语言一个文件：`content/<页面>/index.<语言>.md` 或 `.html`。语言键是 `zh-hans`、`zh-hant`、`zh-hk`、`en`、`ja`、`ru`。
- 首页是 `content/_index.<语言>.html`。俄文没有首页（`content/_index.ru.md` 只用来关掉它）。
- **地址**：目录名默认就是地址，例如 `content/desktop/index.en.html` 发布在 `/en/desktop/`。嵌套的地址写在 front matter 的 `url` 里，**不带开头的斜杠**，Hugo 会加上语言前缀：`url: ios/privacy/` 发布在 `/zh-hans/ios/privacy/`。
- 只有不属于任何语言的页面（网盘授权完成页、根目录 404）才写以 `/` 开头的 `url`，它们不带语言前缀。
- **Markdown 还是 HTML**：长文用 Markdown（`.md`）；首页、下载页、iOS 支持页与隐私政策这类有精心排版结构的页面，用几乎原样迁入的 HTML（`.html`）。HTML 内容文件同样有 front matter，正文里也能用 shortcode。

| 页面 | 目录 | 语言 | 地址 |
|---|---|---|---|
| 首页 | `content/_index.<语言>.html` | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/` |
| 桌面版下载 | `content/desktop/` | 同上，加 ru | `/<语言>/desktop/` |
| 使用手册 | `content/manual/` | zh-hans、zh-hant、en | `/<语言>/manual/` |
| 自动备份与云备份教程 | `content/backups/` | zh-hans、zh-hant、en | `/<语言>/backups/` |
| Markdown 教程 | `content/markdown/` | zh-hans | `/zh-hans/markdown/` |
| 保护机制 | `content/protections/` | zh-hans | `/zh-hans/protections/` |
| 请使用正版 | `content/genuine/` | zh-hans | `/zh-hans/genuine/` |
| Android 隐私政策 | `content/android-privacy/`（`url: android/privacy/`） | zh-hans、en | `/<语言>/android/privacy/` |
| iOS 隐私政策 | `content/ios-privacy/`（`url: ios/privacy/`） | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/privacy/` |
| iOS 支持 | `content/ios-support/`（`url: ios/support/`） | 同上 | `/<语言>/ios/support/` |
| 桌面版隐私政策 | `content/desktop-privacy/`（`url: desktop/privacy/`） | en | `/en/desktop/privacy/` |
| 新桌面版开发故事 | `content/new-desktop-dev-story/`（`url: blog/new-desktop-dev-story/`） | en | `/en/blog/new-desktop-dev-story/` |
| 网盘授权完成 | `content/drives-oauth-<onedrive｜dropbox｜aliyun>/`（`url: /drives/oauth/…/`） | 五种语言并列在一页 | `/drives/oauth/<服务商>/` |
| 根目录 404 | `content/root-404/`（`url: /404.html`） | 五种语言并列在一页 | `/404.html` |

## 二、front matter

| 键 | 含义 |
|---|---|
| `title` | 完整的 `<title>`，模板不再加后缀。沿用旧页的标题；旧标题是文件名一类的错误（`markdown`、`protections`）时，改为「页面主标题 - 站点名」的写法 |
| `description` | meta 描述。旧页有就沿用；没有的，从本页开头的正文里摘原话（不新增事实，不写宣传语），中文以 50～120 字为宜；开头没有合适长度的句子时可以短一些，不硬凑 |
| `lastmod` | 内容最后一次实质修改的日期（YYYY-MM-DD），进 sitemap。迁移时取旧页文件在旧站仓库里最后一次提交的日期 |
| `url` | 见第一节 |
| `image` | 分享卡片用的图片，写 `static/` 下的路径（例如 `images/header_zh_hans.jpg`）；不写就用站点图标 |
| `iosBanner: true` | 输出 Safari 的 iOS 智能横幅（首页、iOS 支持页、iOS 隐私政策） |
| `icons: true` | 输出按钮用的线条图标（`#icon-android`、`#icon-apple`、`#icon-desktop`、`#icon-windows`），首页与下载页用 |
| `jsonld: home` 或 `jsonld: desktop` | 输出结构化数据：首页、下载页 |
| `appName` | 下载页的结构化数据里的软件名，例如「纯纯写作桌面版」 |
| `lastmodFrom: desktop2.json` | 下载页：sitemap 的 lastmod 取 desktop2.json 的发布日期 |
| `script: download.js` | 引用 `assets/js/` 下的脚本（全站只有下载页用） |
| `noindex: true` | 不让搜索引擎收录，也不进 sitemap（授权完成页、404） |
| `layout: bare` 与 `htmlLang: mul` | 不带顶部与页脚的居中单页，几种语言并列（授权完成页、根目录 404） |

## 三、迁移旧页面：正文逐字一致

第一轮迁移只改结构，不改文案（rebuild.md 第一节第 5 条）。

- **正文必须与旧站线上版本逐字一致**，包括标点、全角空格（中文段首的「　　」）、emoji 与错别字。旧站是 `/Users/drakeet/GitHub/writer.drakeet.com` 的 `master`，线上就是它。Typora 导出页以 HTML 为准，不以 `sources/` 里的原稿为准（两者有分叉，例如繁体备份教程）。
- **只允许下列技术性修正**，每处在提交说明里写明：
  - 链接改成新地址（第四节）；失效的图片引用改成可用的同一张图；
  - 去掉语言切换脚本、`data-locale`、`l10n` 一类的多语言包装，去掉 Typora 的 `<span>` 与空标题、`&nbsp;` 空段落；
  - 去掉随页面复制的版权与备案页脚（由全站页脚统一输出，只在简体中文）；
  - 去掉不再成立的提示，例如下载页「需要开启 JavaScript 才能获取最新版本的下载链接」（版本信息已在构建时写进页面）、授权页「将自动关闭」；
  - 写错的页面标题；繁体（香港）页面里混入的台湾用词，改为香港写法（台港用词检查会报出来，依据 iOS 仓库 docs/localization.md 的对照表）；
  - 页内链接指向不存在的锚点时，改指链接文字所指的现有标题，链接文字不变（旧手册里有十几处这样的失效链接）；
  - Typora 代码块（CodeMirror 渲染）的导出痕迹还原为原文：隐藏的测量元素（xxxxxxxxxx）、为显示连续空格插入的不换行空格、把零宽空格画成的红点「•」；
  - 去掉 Typora 给链接加的 `target="_blank"` 与 `class="url"`：站外链接在当前标签页打开，要不要新开标签页由读者自己决定。
- **Typora 段内换行**：旧站 Typora 页的段落是 `white-space: pre-wrap`，段内的字面换行在页面上显示为换行。迁移时在行尾写 `\`（Markdown 的硬换行）保住它；写成软换行会把两行并成一行，比对工具会报出来。
- **锚点原样保留**：旧页正文里每个 `id`（以及 `<a name>`）都要在新页里出现，写法完全相同。Markdown 标题用 `## 标题 {#旧的id}` 显式写出；Hugo 自动生成的 id 与旧的一致时可以不写，但要用比对工具确认。
- **自查**：先构建，再比对正文与锚点，直到两项都通过（允许的修正会表现为差异，逐条确认后在报告里列出）：

```bash
scripts/build-page.sh --out /tmp/site-<页面> content/<页面>
python3 -I scripts/compare-text.py <旧页.html> /tmp/site-<页面>/<语言>/<页面>/index.html --ids [--old-select 'article[data-locale=zh-Hans]'] [--skip footer]
```

  - `build-page.sh` 只拿骨架加上指定的页面构建，几个人同时迁移不同页面时互不干扰；全站页面齐了以后，用 `scripts/build.sh --worktree` 做全站构建，它会再检查站内链接、锚点与期望产物清单。

  - 旧页是一页多语言的（首页、下载页、iOS 两页），用 `--old-select 'article[data-locale=<旧语言代码>]'` 取出对应语言；旧语言代码是 `zh-Hans`、`zh-Hant`、`zh-HK`、`en`、`ja`、`ru`。
  - Typora 页默认取 `#write`，不用写 `--old-select`。
  - 旧页里的页脚由全站页脚代替，比对时加 `--skip footer`。
  - 几个构建可以同时进行：每个构建用自己的 `--out` 目录。
  - 全站页面齐了以后，`scripts/compare-migration.sh` 一次比对全部页面（旧页取自旧站最后一个内容提交 069a297），统一结构或改模板之后用它确认正文没有被改动。
  - 首页的文件不在子目录里，构建时写文件本身，例如 `scripts/build-page.sh --out /tmp/site-home content/_index.en.html`。

## 四、链接

- 站内链接一律写**新地址**，带语言前缀、以斜杠结尾，例如 `/zh-hans/desktop/`、`/en/manual/#…`。旧地址只给站外的存量链接用，由服务器 301 到新地址；构建检查把站内链接指向旧地址视为错误。
- 同一语言里的链接指向同一语言的页面；目标页面没有本语言版本时，沿用旧页原来指向的那种语言（例如繁体首页里的 Android 隐私政策链接到简体版，并保留旧页的「（簡體中文）」注明）。

| 旧链接 | 新地址 |
|---|---|
| `/`、`/?lang=<x>`、`/index`、`/home_en`、`/dorakito`、`/cn/` | `/<语言>/` |
| `/desktop`、`desktop?lang=<x>`、`/desktop2`、`/desktop2_en`、`/desktop_en` | `/<语言>/desktop/` |
| `/desktop2_zh`、`/desktop_zh` | `/zh-hant/desktop/` |
| `/desktop2_ru` | `/ru/desktop/` |
| `/wiki`、`/wiki_zh`、`/wiki_en` | `/zh-hans/manual/`、`/zh-hant/manual/`、`/en/manual/` |
| `/backups`、`/backups_zh`、`/backups_en` | `/zh-hans/backups/`、`/zh-hant/backups/`、`/en/backups/` |
| `/markdown`、`/protections`、`/warning` | `/zh-hans/markdown/`、`/zh-hans/protections/`、`/zh-hans/genuine/` |
| `/privacy`、`/privacy_en` | `/zh-hans/android/privacy/`、`/en/android/privacy/` |
| `/ios/privacy?lang=<x>`、`/ios/support?lang=<x>` | `/<语言>/ios/privacy/`、`/<语言>/ios/support/` |
| `/d/privacy` | `/en/desktop/privacy/` |
| `/blog/NewDesktopDevStory` | `/en/blog/new-desktop-dev-story/` |
| `https://writer.drakeet.com/…` 写成的站内链接 | 同上，去掉域名 |

## 五、图片

- `static/images/` 是旧站图片，按原路径、原字节发布（Android 等在直接引用），**不改、不删、不新增**。
- 新页面里的图片用 `img` shortcode，原图放在 `assets/img/`（需要的图片已经复制过去）。它按显示宽度输出 1x 与 2x 两档 WebP，文件名带内容指纹：

```
{{< img src="img/header_zh_hans.jpg" alt="……" class="banner" width="680" loading="eager" >}}
```

  - `width` 是显示宽度（CSS 像素），正文宽度是 680；首屏的大图写 `loading="eager"`，其余用默认的 `lazy`。
  - 单独成段时，Hugo 会去掉 shortcode 两侧的 `<p>`；样式表已经让直接位于正文下的图片成为块级并带段落的下边距，不需要再用 `<p>` 包。
  - `alt` 沿用旧页的写法，旧页没有就写一句说明图片内容的话。
- 页面图标（首页与下载页的 72px 图标）直接写 `<img src="/images/icon512.png" alt="" width="72" height="72">`。

## 六、下载页的动态部分

版本、发布日期、安装包的地址与大小、校验值、最近更新都取自仓库根目录的 `desktop2.json`（桌面版 release.sh 写入），用 shortcode 在构建时写进页面，按钮文字写在内容文件里：

```html
<h2 id="download">下载{{< release >}}</h2>
<div class="downloads">
{{< download file="windows-x64" icon="windows" name="下载 Windows 版" detail="x64" >}}
{{< download file="macos-aarch64" icon="apple" name="下载 macOS 版" detail="Apple 芯片" >}}
{{< download file="macos-x64" icon="apple" name="下载 macOS 版" detail="Intel 芯片" >}}
</div>
<p class="others" hidden>其他安装包：{{< other-download file="macos-aarch64" icon="apple" label="macOS（Apple 芯片）" >}}…</p>
<details class="note"><summary>安装包的 SHA-256 校验值</summary>{{< checksums >}}</details>
<h2>最近更新<span class="aside">v{{< notes version=true >}}</span></h2>
{{< notes >}}
```

`download.js` 只做渐进增强：识别出访客的系统后，只把适合的版本留作主按钮，其余移到「其他安装包」一行；`data-chip-hint` 的段落在只剩一个主按钮时隐藏。没有脚本时三个主按钮并列。

## 七、市场差异

以下内容只放在简体中文（`zh-hans`）的文件里，其他语言一律不写（根目录 AGENTS.md）：

- ICP 备案号、公安备案号、`beian.miit.gov.cn`（由页脚自动输出，正文里不写）；
- 蓝奏云、「国内下载」一类中国大陆视角的下载提示；
- 360 安全软件及其特有的错误信息；
- OneDrive、阿里云盘、坚果云之间的切换提示，以及带中文界面的 `DriveOnAndroidGuide.jpg`。

「阿里云盘」作为支持的网盘之一，可以出现在各语言里。繁体分台湾（`zh-hant`）与香港（`zh-hk`），用词按各自习惯。

## 八、页面结构

所有页面的结构与首页一致（Drakeet 2026-11-07：旧站的 Typora 页一律规范成首页的风格、统一管理）：

- 每页恰好一个 h1，就是页面的主标题；章节用 h2，小节用 h3，不跳级。
- 标题只用来表达结构，不拿来加粗或放大一句话；需要强调的一行写成段落加 `<strong>`，旧锚点的 id 写在这个段落上（例如「请使用正版」页的下载一行）。
- 标题里不放链接：回首页有顶部导航。
- 文档类页面（隐私政策、教程）的日期段写成 `<p class="meta">`（多行用 `<br>`），末尾的署名写成 `<p class="company">`，与 iOS 隐私政策一致。
- 首页中文段落开头的「　　」是写在文字里的缩进，长文页面不加。
- 统一结构只改标记，不改文字：改完用 `scripts/compare-migration.sh` 确认正文与锚点与旧页一致。
