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
| 请使用正版 | `content/genuine/` | zh-hans、zh-hant、en、ja | `/<语言>/genuine/`（旧地址 `/warning` 只跳到简体页） |
| Android 隐私政策 | `content/android-privacy/`（`url: android/privacy/`） | zh-hans、en | `/<语言>/android/privacy/` |
| iOS 版介绍 | `content/ios/` | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/` |
| iOS 隐私政策 | `content/ios-privacy/`（`url: ios/privacy/`） | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/privacy/` |
| iOS 支持 | `content/ios-support/`（`url: ios/support/`） | 同上 | `/<语言>/ios/support/` |
| 桌面版隐私政策 | `content/desktop-privacy/`（`url: desktop/privacy/`） | en | `/en/desktop/privacy/` |
| 新桌面版开发故事 | `content/new-desktop-dev-story/`（`url: blog/new-desktop-dev-story/`） | en | `/en/blog/new-desktop-dev-story/` |
| 博客文章 | `content/blog-<slug>/`（`url: blog/<slug>/`），见第十节 | 各篇不同 | `/<语言>/blog/<slug>/` |
| 博客列表页 | `content/blog/_content.gotmpl`（内容适配器，按文章自动生成），见第十节 | 有博客文章的语言 | `/<语言>/blog/` |
| 网盘授权完成 | `content/drives-oauth-<onedrive｜dropbox｜aliyun>/`（`url: /drives/oauth/…/`） | 五种语言并列在一页 | `/drives/oauth/<服务商>/` |
| 根目录 404 | `content/root-404/`（`url: /404.html`） | 五种语言并列在一页 | `/404.html` |

## 二、front matter

| 键 | 含义 |
|---|---|
| `title` | 完整的 `<title>`，模板不再加后缀。沿用旧页的标题；旧标题是文件名一类的错误（`markdown`、`protections`）时，改为「页面主标题 - 站点名」的写法 |
| `description` | meta 描述。旧页有就沿用；没有的，从本页开头的正文里摘原话（不新增事实，不写宣传语），中文以 50～120 字为宜；开头没有合适长度的句子时可以短一些，不硬凑 |
| `lastmod` | 内容最后一次实质修改的日期（YYYY-MM-DD），进 sitemap。迁移时取旧页文件在旧站仓库里最后一次提交的日期 |
| `url` | 见第一节 |
| `image` | 分享卡片用的图片，写 `static/` 下的路径；写了就用大卡片，不写就用站点图标的小卡片。首页与 iOS 版介绍页用 `img/og/<语言>.jpg`（`assets/` 下，1200×630，由 `scripts/og-images.py` 从 App Store 的页头生成，港繁共用 zh-hant；构建时加内容指纹、原样发布为 JPEG），下载页用 `static/` 下的桌面版截图 |
| `iosBanner: true` | 输出 Safari 的 iOS 智能横幅（首页、iOS 版介绍页、iOS 支持页、iOS 隐私政策） |
| `icons: true` | 输出按钮用的线条图标（`#icon-android`、`#icon-apple`、`#icon-desktop`、`#icon-windows`），首页、下载页与 iOS 版介绍页用 |
| `jsonld: home`、`jsonld: desktop` 或 `jsonld: ios` | 输出结构化数据：首页、下载页、iOS 版介绍页。`ios` 另从正文的 `<h2 id="faq">` 一节生成 FAQPage（每个 h3 一问，其后的段落与列表是回答），这一节缺了构建会失败 |
| `jsonld: article` | 博客文章（第十节）：输出 BlogPosting，正文有「常见问题」一节（`<h2 id="faq">`）时另加 FAQPage（这一节可以没有）；末尾由模板输出日期与博客列表页的链接；收进本语言的博客列表页。要同时写 `date` |
| `date` | 发布日期（YYYY-MM-DD），博客文章必须写：进结构化数据、Open Graph、文章末尾与列表页的排序 |
| `author` | 只用于有署名的博客文章（目前只有 Drakeet 第一人称写的开发故事）：BlogPosting 的作者写成这个人；不写时作者是本语言的站点名 |
| `appName` | 下载页与 iOS 版介绍页的结构化数据里的软件名，例如「纯纯写作桌面版」「纯纯写作 iOS 版」 |
| `lastmodFrom: desktop.json` | 下载页：sitemap 的 lastmod 取 desktop.json 的发布日期 |
| `script: download.js` | 引用 `assets/js/` 下的脚本（全站只有下载页用） |
| `noindex: true` | 不让搜索引擎收录，也不进 sitemap（授权完成页、404） |
| `layout: bare` 与 `htmlLang: mul` | 不带顶部与页脚的居中单页，几种语言并列（授权完成页、根目录 404） |
| `company` | 页脚版权一行的主体（页脚只在简体中文输出）。不写就是界面文字里的 company，即苏州小白迷雾科技有限公司；简体的 iOS 支持页与隐私政策写 `Drakeet Co., Ltd.`：iOS 版在 App Store 上的销售商是它，与正文的署名一致，同一页不出现两个主体 |

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
  - 全站页面齐了以后，曾用 `scripts/compare-migration.sh` 一次比对全部页面（旧页取自旧站最后一个内容提交 069a297）。第 F 步重写了手册与教程之后，大半页面本来就与旧页不同，它已退役删除。
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
| `/ios`（对外张贴用的不带语言的入口，站内不用） | `/<语言>/ios/` |
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
- iOS 版介绍页的截图是 App Store 的商店截图：取 iOS 仓库 `store-assets/screenshots/<语言>/` 里 iPhone 的那五张，用 `sips` 缩到 660 宽、存成 JPEG 放在 `assets/img/ios/<语言>-<序号>-<画面>.jpg`（香港繁体共用 zh-hant 的一套），页面里写成 `<ul class="shots">` 里的 `img` shortcode，`width="216"`。商店截图更新后这里跟着换。
- 页面图标（首页与下载页的 72px 图标）直接写 `<img src="/images/icon512.png" alt="" width="72" height="72">`。

## 六、下载页的动态部分

版本、发布日期、安装包的地址与大小、校验值、最近更新都取自仓库根目录的 `desktop.json`（桌面版 release.sh 写入），用 shortcode 在构建时写进页面，按钮文字写在内容文件里：

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
- **署名的主体**：简体中文写「苏州小白迷雾科技有限公司」，其余语言一律写「Drakeet Co., Ltd.」（日本公司的英文名，日文页也是这样写）。例外是简体的 iOS 隐私政策与 iOS 支持页：iOS 版在 App Store 上的销售商是 Drakeet Co., Ltd.，正文与署名都写它，页脚用 front matter 的 `company` 跟着改（第二节）。
- 首页中文段落开头的「　　」是写在文字里的缩进，长文页面不加。
- 统一结构只改标记，不改文字：改前改后各构建一份产物（`scripts/build-page.sh --out <目录>`），比对这几页的正文与锚点没有变化。

## 九、llms.txt 与 llms-full.txt

根目录的两个纯文本文件，给 AI 助手与检索系统读（rebuild.md 4.10）。两者都只有一份、不按语言区分，不参与语言协商；都已写进 URL 合同与站点规则的静态路径。页面的 `<head>` 里不加指向它们的链接：llms.txt 的约定只有根目录这个位置，没有约定 `<link>` 的写法，不用自造的 rel。

| | `/llms.txt` | `/llms-full.txt` |
|---|---|---|
| 定位 | 索引：一段事实性概述，加上按主题分节的主要页面链接 | 全文：主要页面的正文合成一个 Markdown 文件，一次读完 |
| 来源 | 手写的 `static/llms.txt` | 构建时由 `layouts/index.llmsfull.txt` 从站内页面生成，不手写 |
| 语言 | 英文；链接注明有哪些语言版本 | 以英文版为主体，后面附只有简体中文的页面的原文 |

**llms.txt 的写法**按 llmstxt.org 的约定：一个 H1（产品名），一个引用块写概述，随后可以有不带标题的段落，再往下是 H2 分节的链接列表，每项「`[名称](地址)`：一句说明」；次要的页面放在最后的 `## Optional`。第一个 H2 之前只放概述：llms-full.txt 的开头原样取这一部分，两处说法因此始终一致，改概述只改 llms.txt。概述只写事实，不写价格（各地区不同，以商店显示为准）。

**llms-full.txt 的构成**：开头是上面的概述、语言构成与各语言首页、隐私政策的链接与目录；之后每个页面一部分，以页面自己的一级标题开头，下一行写来源地址。收录哪些页面、什么顺序写在模板开头的 `$sources` 里；页面正文转成 Markdown 的规则在 `layouts/partials/llms-markdown.html`（Markdown 源的页面保留原来的标题层级与写法，HTML 源的页面保留小标题、列表与链接，图片、隐藏的重复链接与安装包校验值去掉，链接一律改成绝对地址）。隐私政策只给链接，不收全文。

**新增或改动页面时**：

- 新增页面：llms.txt 里加一项链接，写在对应的分节里，各语言版本以实际存在的文件为准；只有简体中文的页面注明「Simplified Chinese only」。产品介绍与帮助类的页面（介绍页、手册、教程）同时在 llms-full.txt 模板的 `$sources` 里加一项：有英文版的收英文版，只有简体中文的放在简体那几页一起。隐私政策、授权完成页、404 与开发故事一类的文章不收进 llms-full.txt。
- 删除页面或改地址：两处一起改。模板找不到 `$sources` 里的页面时构建会失败；llms.txt 是手写的，构建检查不核对其中的链接，要自己核对。
- 只改页面的文字：llms-full.txt 随下一次构建自动更新，不用动；概述里说到的事实（平台、系统要求、试用与会员）变了，改 llms.txt 的概述。
- 改了 HTML 页面的标记结构（截图列表、下载按钮、校验值的写法，标题旁的 aside 等）：构建后通读 llms-full.txt 里对应的部分，转换规则按标记逐条处理，标记变了可能需要跟着改。
- llms-full.txt 在根目录，构建检查按非大陆的产物扫描它的市场差异（`ops/market-rules.toml`）。附在后面的简体页面一旦写进只适合中国大陆的内容，构建会失败：那时把这一页从 `$sources` 里拿掉，不要给 llms-full.txt 加豁免。

## 十、博客文章

博客文章回答写作者搜索的具体问题，面向搜索引擎与 AI 检索（rebuild.md 4.4、4.10）。「博客文章」的唯一标志是 front matter 的 `jsonld: article`：列表页、结构化数据与文章末尾都按它认，不按目录名。早先的 `new-desktop-dev-story` 也是一篇。

**目录与 front matter**：一篇文章一个顶层目录 `content/blog-<slug>/`，每种语言一个 `index.<语言>.md`（zh-hans、zh-hant、en、ja）。slug 只用小写字母、数字与短横：站点规则清理地址后面粘着的杂字符时只认这种写法（rebuild.md 4.5）。

```yaml
---
title: <h1 的文字> - 纯纯写作
description: <50～120 字，含核心检索词的原话，只写事实>
date: 2026-11-13
lastmod: 2026-11-13
url: blog/<slug>/
jsonld: article
---
```

- 同一篇文章的各语言版本放在同一个目录里，hreflang 自动只列出确实存在的语言；`url` 各语言相同（Hugo 加上语言前缀）。
- `date` 是发布日期，必须写（缺了构建失败）；`lastmod` 是最后一次实质修改的日期，修改正文时跟着改。两者相同时文章末尾只写发布日期。日期在未来的文章（以及草稿）不发布，列表页也不收。
- front matter 之后写一段 HTML 注释，说明定位与目标检索词、关于纯纯写作的事实出自手册哪几节、维护提示（手册改了相关说法，这里跟着改）。

**正文**：恰好一个 `#` 一级标题（不带站点名，它就是列表页里的链接文字与结构化数据的 headline），章节 `##`、小节 `###`，不跳级，标题里不放链接（第八节）。正文里不写日期行与署名，模板会在末尾输出发布日期、更新日期（与发布日期不同时）与「更多文章」一行（回到本语言的博客列表页）。对比用 Markdown 表格，窄屏时表格在自身内部横向滚动，不撑破页面。

**常见问题一节**：文末之前写 `## 常见问题 {#faq}`（英文 `## FAQ {#faq}`，日文 `## よくある質問 {#faq}`，id 一律是 `faq`），每个 `###` 是一个问题，其后的段落与列表是回答。模板据此生成 FAQPage（`layouts/partials/faq-page.html`，与 iOS 版介绍页共用）：回答转成纯文本，加粗与链接只留文字，所以回答要能单独读懂，不写「如上所述」「见下表」。这一节可以没有；有的话至少一个问题，`id="faq"` 的 h2 只能有一个，否则构建失败。

**列表页**：`/<语言>/blog/` 由 `content/blog/_content.gotmpl`（Hugo 的内容适配器）生成，不用为它写内容文件：

- 构建时看 content/ 下每个页面目录里本语言的文件，有一篇 `jsonld: article`、不是草稿、发布日期不在未来的，就生成这种语言的列表页；一篇也没有就不生成。新语言的第一篇文章到了，列表页、首页的入口与文章末尾的链接都会自动出现。
- 列出本语言的全部博客文章：标题（一级标题的文字）、发布日期、description，按发布日期从新到旧，同一天的按标题排序。sitemap 里列表页的 lastmod 取本语言文章里最晚的 lastmod。
- 列表页自己的 title、description、h1 与引言写在 `_content.gotmpl` 的 `$copy` 里，每种语言一项，只写泛指的主题，不点名具体文章。要给一种还没有的语言（例如香港繁体）开博客，先在那里加文案，再在 `i18n/<语言>.toml` 里补上博客的几项界面文字（dateFormat 等），缺了构建会报错。
- 首页的入口是 `{{< blog-link >}}链接文字{{< /blog-link >}}`（香港繁体首页写 `lang="zh-hant"`，指向台湾繁体的列表页），列表页不存在时整项不输出，不会留下死链。
- 万一列表页与文章两边认文章的口径不一致（例如 front matter 不是 `---` 包起来的 YAML），构建会失败并说明原因。

**新增一篇文章要做的事**：

1. 写 `content/blog-<slug>/index.<语言>.md`，用 `scripts/build-page.sh --out <临时目录> content/blog-<slug> content/manual` 构建自查（博客列表页会一起带上）；
2. `ops/contract.tsv` 的「博客列表页」几行之后，给每个语言版本加一行 `/<语言>/blog/<slug>/`，期望 200 与指向自身的 canonical（写法照旁边的行）；这种语言的列表页是第一次出现时，同时给列表页加一行；
3. `scripts/build.sh --worktree --update-expected` 重写期望产物清单，核对多出的正是这几页（以及新出现的列表页），再跑一遍 `scripts/build.sh --worktree` 与 `scripts/test-caddy.sh`；
4. llms.txt：在博客那一节加一项链接，注明有哪些语言（只有简体的写「Simplified Chinese only」），见第九节。博客文章默认不收进 llms-full.txt（与开发故事相同）：它们以通用的写作问题为主，llms-full.txt 收的是产品介绍与帮助；附在后面的简体页面也要过非大陆的市场检查，文章里写了只适合大陆的内容就不能收；
5. 其余不用手动改：列表页、hreflang、sitemap、文章末尾的链接与首页的入口都由模板生成。
