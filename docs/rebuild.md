# 官网重建

纯纯写作官网（writer.drakeet.com）从零重建的专项正本：目标、调研结论、URL 合同、站点架构、服务器方案、部署方式、实施步骤与验收。阶段进度只写在「当前游标」；其余各节是现役合同，实施中有变化时直接改对应小节。

## 当前游标

- **第 0 步（方案）**：本文为初稿，待 Drakeet 过目第十节的待定事项后开工。
- 仓库：`rebuild` 分支的第一个提交（a69f659）清空了旧站全部文件，新站在这个分支上开发；`master` 原样保留旧站，旧站照常从 `master` 部署，直到第 5 步切换。旧站另有完整副本在本机 `/Users/drakeet/GitHub/writer.drakeet.com.old`。
- 收尾时必须做、不论进行到哪一步都不能漏的两件事：
  - 提醒 Drakeet 收回重建期间为服务器管理临时开放的免密 sudo；
  - 切换一周后，请 Drakeet 在阿里云控制台删除切换前做的手动快照。

## 一、目标与原则

**目标**

1. 站点架构：源文件可维护（Markdown 加少量模板），构建产物是纯静态文件，部署原子、可以一条命令回滚。
2. 本地化：每种语言一个独立地址，搜索引擎与 AI 能识别各语言版本；各语言之间的市场差异（备案号、蓝奏云、网盘切换提示等）由结构保证，不靠人记。
3. 服务器：受支持的系统、自动安全更新、自动证书、最小暴露面，全部配置写进仓库、可以重复执行。
4. 已发布的 App、服务端与外部平台依赖的地址一个不断（第三节）。
5. 文本内容沿用旧站，本轮不改写文案。只修正技术性的错误，例如失效的图片引用、从未生效的自动关闭脚本、写错的页面标题，各处在对应小节写明。

**取舍原则**

- 先问是否必须。不为假想的需求加组件；一个机制能解决的，不引入第二个。例如证书交给 Web 服务器自己管理，不再另配 certbot 和定时任务。
- 已发布 App 用到的地址就是接口。路径和字节都按契约对待，不为整洁而挪动。
- 少依赖、长期稳定，优先于写法时髦。构建在存有各类签名与发布凭据的那台 Mac 上进行，依赖面越小越好。
- 失败要显式。每次部署后自动跑 URL 合同检查，失败就报错，并给出一条回滚命令。

## 二、调研结论（摘要）

调研于 2026-11-07 完成：9 个只读调研（旧站清单、静态资源、三端与其他项目对官网地址的引用、服务器审计、集成点、站点技术、运维技术、本地化），加上服务器只读审计与 52 天访问日志的聚合统计。完整报告存在本机、不入库：`/Users/drakeet/Documents/iOS/writer/evidence/website-rebuild-2026-11/`。

### 2.1 旧站

- 面向用户的 HTML 共 44 个：
  - 手写多语言页 4 个：首页、桌面版下载页、iOS 支持页、iOS 隐私政策。一页内含五六种语言，由内联脚本选一种显示；
  - Typora 导出页 17 个：单语言，靠文件名后缀区分语言，内联的主题 CSS 约占体积一半；
  - 跳转页 6 个、网盘授权成功页 15 个、DeepOCAT 双语页 2 个；
  - 另有 `desktop2.json` 与 Apple 关联域名文件。
- 服务器把 git 检出直接当作站点根目录，`.git/`、`AGENTS.md`、`sources/`、Jekyll 遗留文件都能被下载。52 天内 `.git/` 被请求 7.2 万次，其中有专门的扒取工具。仓库本身是公开的，所以目前没有泄露额外内容，但这种部署方式本身不可取。
- nginx 规则把一切不存在的路径改写成 `/$1.html`，形成循环，返回 500。52 天里共 9.9 万次，大头是缺失的 `/favicon.ico`。
- 没有 HTTP/2、缓存头、安全响应头、robots.txt、sitemap、hreflang 和 404 页。
- 判断用户语言的逻辑至少散在 7 处：4 份页面脚本、Android、rebase-server 两处。后缀命名也不统一：`_zh` 实指台湾繁体并兼作香港，日文用 `_jp`。
- Typora 页的译文明显滞后，例如 `wiki_en` 少 16 条问答，`backups_en` 停在 2023 年。
- 现存故障：rebase-server 给日文用户拼的授权成功页是 `*_ja`，站上的文件却叫 `*_jp`。日文用户在桌面版授权网盘后看到的是 500。

### 2.2 服务器

- 阿里云上海 ECS：1 vCPU、1 GiB 内存、40 GB 系统盘，没有数据盘；公网 IP 是 EIP。
- 系统是 Ubuntu 20.04.2，标准支持已于 2025-05 结束。内核仍是 2021 年的版本，之后一直没有重启（已连续运行 695 天）。有 302 个待升级的包，其中 224 个来自安全更新；没有配置自动更新。
- nginx 1.24 来自已停更的 nginx.org focal 源。证书由 certbot 续期，另有一个每两个月停一次 nginx、强制续期的 root 定时任务，两套机制并存。
- SSH 只接受密钥、禁止 root 登录，这一点符合要求。但主机防火墙实际没有启用。
- 同一台机器还托管着：
  - drakeet.com 与 www.drakeet.com：一个 OCAT 页面，文件只存在服务器上，放在 nginx 软件包的默认目录里；
  - 一个个人用的代理服务。
- `journal` 日志不设上限，已占 3.5 GB。

### 2.3 流量（2026-09-16 至 11-07，共 175 万条请求）

- **App 拉取的图片是流量主体**。`/images/papers/*.jpg`（稿纸背景）和 `/images/pro/**/*.webp`（Pro 介绍页）每个文件被请求 1 万到 11 万次，基本来自 Android。
- **页面**：`/` 6.9 万次，`/desktop2` 1.75 万次，`/desktop2.json` 1.3 万次，`/desktop` 8.4 千次，`/wiki` 4.5 千次，`/backups` 4.2 千次。
- **`?lang=` 的取值**：zh-Hans 3405 次、en 1420 次、zh-Hant 949 次、zh-HK 664 次、ja 572 次、ru 189 次。
- **`/ocat/jars/`**：52 天传出 151 GB。每个版本只在它是最新版的那几天被桌面版自动更新下载。服务器上积累了 71 个版本、6.5 GB，实际只需要当前版本。

## 三、URL 合同

已发布的 App 改不了，外部平台登记的地址也不受我们控制，所以下列地址在新站必须继续响应。表中三种处理方式的含义：

- **原样**：在原地址直接返回原内容，不经过任何跳转；
- **301**：永久跳到新地址，查询串原样带上，浏览器会自动保留 `#锚点`；
- **协商**：按语言 302 到对应语言的新地址，规则见 4.5。

| 地址 | 依赖方 | 新站处理 |
|---|---|---|
| `/.well-known/apple-app-site-association` | iOS 关联域名（webcredentials，1.0 起各版写死），Apple 的 CDN 从海外抓取 | 原样，`Content-Type: application/json`，绝不跳转 |
| `/images/papers/{0,4,5,6}.jpg` | Android 稿纸：完整 URL 存进用户设置，并随同步传到其他设备 | 原样，字节永不改变 |
| `/images/pro/{0..5}.webp`、`/images/pro/en/{0..5}.webp`、`/images/pro/(en/)PureWriterDesktop(Dark).webp` | Android Pro 介绍页、首次启动预取 | 原样 |
| `/images/icon512.png` | Android「关于」页 | 原样 |
| `/images/` 下其余旧图片，含 ocat.app 热链的 5 张 | 第三方 README；ocat.app 的 og:image、JSON-LD 与 PWA manifest | 原样，整个目录保留 |
| `/desktop2.json` | 桌面版 release.sh 发版后的线上校验（curl 不跟随跳转） | 原样 |
| `/ocat/jars/PureWriter2-<版本>-<平台>.jar` | rebase-server 给连不上 Cloudflare 的国内客户端分流约一半的自动更新下载；桌面版 CI 的兜底下载 | 原样（文件放在站点目录之外，见 5.6） |
| `/`、`/index`、`/index.html`（含 `?lang=`、`#ios-*` 等锚点） | Android「需要更新」对话框、iOS 示例文章、App Store 营销网址、外部链接 | 协商；`?lang=` 合法时 301 |
| `/desktop`、`/desktop.html`（含 `?lang=` 与 `#download-*`） | Homebrew、Scoop、AUR 等包管理器的清单、Android 文案 | 协商 |
| `/desktop2`、`/desktop2_en`、`/desktop_en` | 已安装桌面版的「检查更新」、Windows「已安装的应用」里的链接、rebase-server、Android 文案、winget 清单 | 协商（这几个旧地址本来就不带语言） |
| `/desktop2_zh`、`/desktop_zh` | rebase-server（台湾）、Android 繁体文案 | 301 到繁体（台湾）桌面页 |
| `/desktop2_ru` | rebase-server、俄语用户的通知 | 301 到俄文桌面页 |
| `/ios/privacy`、`/ios/support`（含 `?lang=`，可能是 iOS 30 种界面语言中的任何一种） | iOS App 内链接；App Store Connect 的隐私政策网址与支持网址 | 协商；`?lang=` 是页面支持的语言时 301，其余按浏览器语言 |
| `/wiki`、`/wiki_zh`、`/wiki_en` | Android 帮助入口 | 301 到对应语言的使用手册 |
| `/backups`、`/backups_zh`、`/backups_en` | Android 备份教程入口（`_zh` 与 `_en` 是 2019—2023 年的版本在用）、外部 README | 301 |
| `/warning` | Android 检测到篡改时打开的提示页，存量极大 | 301 |
| `/privacy`、`/privacy_en` | 应用商店与 Google OAuth 同意屏幕很可能登记了它们（仓库里无法核实） | 301 |
| `/home_en` | Google OAuth 同意屏幕登记的应用首页（据旧页正文） | 301 到英文首页 |
| `/blog/NewDesktopDevStory` | 桌面版菜单（非中文界面），路径大小写敏感 | 301 |
| `/d/privacy` | 桌面版隐私政策（消费方未核实） | 301 |
| `/drives/oauth/{OneDrive,Dropbox,Aliyun}` 加 `_en`、`_zh`、`_ja`、`_ko` 后缀，以及 `_jp` | rebase-server 在桌面版授权完成后 307 过来的落地页 | 301 到新的授权完成页，同时修好 `_ja`（见 4.6） |
| `/markdown`、`/protections` | 站内链接、外部 README | 301 |
| `/dorakito`、`/cn/` | 没有站内入口的旧首页（日文版、大陆精简版） | 301 到对应语言的首页 |
| `/ocat/ocat`、`/ocat/privacy`、`/ocat/terms` | 2025-03 的 DeepOCAT 页面，目前没有任何仓库引用 | 本轮原样保留，最后阶段与 drakeet.com 一并决定 |
| `/v28/`、`/v28.1/` | 已停用的临时下载页 | 301 到首页 |
| `/about`、`/pro` | Android 清单里未经验证的网页链接（没有 autoVerify） | 301 到首页 |
| 所有旧页面的 `.html` 写法 | 旧 nginx 规则让它们都能访问 | 301 |
| `http://` 下的任意路径 | 外部旧链接 | 301 到 https 的同一路径，再按上表处理 |

新站不再提供仓库文件：`.git/`、`sources/`、`AGENTS.md`、Jekyll 主题文件、`assets/`（旧主题残留，线上本来就返回 500）等，一律返回 404。

`www://writer.drakeet.com/...` 是 OneDrive 授权回调和 App 内路由用的自定义 scheme，请求不会到达网站，与本站无关。但这串地址在 App 和 Azure 的注册信息里都不能改。

## 四、站点架构

### 4.1 站点生成器：Hugo（标准版，固定版本）

候选有四个：Hugo、Astro、Eleventy，以及不用生成器、手写 HTML 加一个小脚本。选 Hugo，理由：

1. **内容形态匹配**。本站约 15 类页面，以长篇文字为主，各页覆盖的语言各不相同。Hugo 原生的多语言模型按页面对应译文，`.Translations` 只列出实际存在的译文；hreflang 和语言切换器自然也只包含存在的语言，不用自己写判断。
2. **依赖最少**。单一二进制，不需要 Node、npm 和任何第三方包。Astro 7 的核心会拉进约 255 个 npm 包，大版本三四个月就换一次，遥测默认开启。Eleventy 正处在更名和 v4 长期停在 alpha 的过渡期。
3. **长期稳定**。版本固定后可以一直用下去，弃用的功能先提示 15 个次版本才会报错，升级按计划进行。
4. **自带所需的一切**：Markdown（Goldmark）、目录、图片转 WebP/AVIF、资源指纹、压缩、sitemap、自定义输出格式（用来生成 `llms.txt` 与 Markdown 版页面）。

代价是 Go 模板的可读性。缓解办法是模板少而短，复杂逻辑放进 partial 并加中文注释。手写方案的透明度最高，但 hreflang、目录、锚点、指纹都要自己写、自己测，长期看并不更省事。

URL 布局、重定向、语言协商和部署全部写在 Web 服务器配置与脚本里，不依赖生成器的私有行为。例如重定向不用生成器的 meta refresh 别名。这样以后即使换生成器，URL 也不用动。

### 4.2 仓库结构

```
AGENTS.md            站点约定（含市场差异规则），CLAUDE.md 引用它
docs/rebuild.md      本文
hugo.toml            站点配置：语言、输出格式、Markdown 选项
content/             页面正文：每个页面一个目录，每种语言一个文件（index.zh-hans.md、index.en.md……）
layouts/             模板
assets/              样式表与脚本（经 Hugo 处理，输出带指纹的文件名）
i18n/                界面文字（导航、页脚、按钮等），每种语言一个文件
data/desktop2.json   桌面版发版数据，由桌面版 release.sh 写入
static/images/       旧站全部图片，按原路径原样发布
static/.well-known/  apple-app-site-association、security.txt
static/ocat/         DeepOCAT 旧页，原样（最后阶段再定去留）
ops/                 服务器配置：初始化脚本、Caddyfile、JAR 同步命令、URL 合同检查
scripts/             构建、预览、检查、部署与回滚
```

视觉沿用 2026-09 以来手写页的风格：系统字体栈，跟随深浅色，配色克制，正文限制行宽；Typora 页并入同一套样式表。不引用任何外部字体和第三方资源，备案图标改为本站托管。

### 4.3 本地化组织

**URL：所有语言都带前缀；`/` 和旧的无前缀地址只做协商。**

- 正式地址是 `/<语言>/<页面>/`，例如 `/zh-hans/desktop/`、`/en/manual/`。
- `/`、`/desktop`、`/ios/privacy` 等旧地址按 4.5 的规则 302 到某种语言。

另一种方案是简体中文不带前缀、其他语言带前缀。没有选它，理由：

1. 旧的多语言地址（`/`、`/desktop`、`/ios/privacy`）现在都会按访客语言显示。App Store 的审核员和外国用户需要看到英文，iOS App 也会带上 `?lang=`。简体中文若占用无前缀地址，这些入口就会固定显示中文。
2. 所有语言都带前缀，结构对称，模板与重定向规则都更简单。
3. Google 建议每种语言用独立 URL，`x-default` 本来就是为「按语言跳转的入口」设计的。

**语言键**：沿用 iOS App 与 `desktop2.json` 已有的那套，URL 里用小写。

| 语言 | URL 段 | hreflang | html lang | og:locale | 旧后缀 |
|---|---|---|---|---|---|
| 简体中文 | `zh-hans` | `zh-Hans` | `zh-Hans` | `zh_CN` | 无后缀 |
| 繁体中文（台湾） | `zh-hant` | `zh-Hant` | `zh-Hant-TW` | `zh_TW` | `_zh` |
| 繁体中文（香港） | `zh-hk` | `zh-HK` | `zh-Hant-HK` | `zh_HK` | 无 |
| 英文 | `en` | `en` | `en` | `en_US` | `_en` |
| 日文 | `ja` | `ja` | `ja` | `ja_JP` | `_jp`（以及 rebase-server 拼的 `_ja`） |
| 俄文（仅桌面版下载页） | `ru` | `ru` | `ru` | `ru_RU` | `_ru` |
| 韩文（仅网盘授权完成页） | `ko` | `ko` | `ko` | `ko_KR` | `_ko` |

- html lang 用 `zh-Hant-TW`、`zh-Hant-HK` 这种带文字代码的写法：CSS 的 `:lang(zh-Hant)` 能同时匹配台湾与香港，繁体字体规则只需写一次。
- 只有繁体（台湾）版本、没有香港版本的页面（例如使用手册），hreflang 标 `zh-Hant`，香港用户也会匹配到它，不另做重复页面。

**源文件**：每个页面一个目录，每种语言一个 Markdown 文件，例如 `content/manual/index.zh-hans.md`、`index.zh-hant.md`、`index.en.md`。同一页面的各个译文放在一起，便于对照和审阅。

**市场差异由结构保证**，不再靠在每页里记得删：

- 备案号只由页脚 partial 在简体中文的语言参数里取到时才输出；
- 蓝奏云、360、网盘切换提示一类只适合大陆的内容，只写在简体中文文件里；
- 构建检查确认它们没有出现在其他语言的文件里。法律页面（隐私政策）不受这条检查约束，因为法律文本需要完整披露。

**回退顺序**：页面缺某种语言时，zh-hk 回退到 zh-hant，再回退到 zh-hans；ja、ko、ru 回退到 en。语言切换器只列出页面实际存在的语言，点不存在的语言则去该语言的首页。

**记住手动选择**：

- 语言切换器是普通链接，不用 `<select>`；
- 一个外部小脚本在用户点选时写入 cookie `pw_lang`；
- 服务器协商 `/` 等入口时优先读这个 cookie。

旧站把同样的选择存在 localStorage 里，服务器读不到，这是唯一保留下来的旧行为。

### 4.4 页面与新地址

| 页面 | 现有语言 | 新地址 | 旧地址 |
|---|---|---|---|
| 首页 | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/` | `/`、`/index(.html)`、`/home_en`（英）、`/dorakito`（日）、`/cn/`（简） |
| 桌面版下载 | 同上，加 ru | `/<语言>/desktop/` | `/desktop`、`/desktop2*`、`/desktop_*` |
| 使用手册 | zh-hans、zh-hant、en | `/<语言>/manual/` | `/wiki`、`/wiki_zh`、`/wiki_en` |
| 自动备份与云备份教程 | zh-hans、zh-hant、en | `/<语言>/backups/` | `/backups`、`/backups_zh`、`/backups_en` |
| Markdown 教程 | zh-hans | `/zh-hans/markdown/` | `/markdown` |
| 保护机制 | zh-hans | `/zh-hans/protections/` | `/protections` |
| 请使用正版 | zh-hans | `/zh-hans/genuine/` | `/warning` |
| Android 隐私政策 | zh-hans、en | `/<语言>/android/privacy/` | `/privacy`、`/privacy_en` |
| iOS 隐私政策 | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/privacy/` | `/ios/privacy` |
| iOS 支持 | 同上 | `/<语言>/ios/support/` | `/ios/support` |
| 桌面版隐私政策 | en | `/en/desktop/privacy/` | `/d/privacy` |
| 新桌面版开发故事 | en | `/en/blog/new-desktop-dev-story/` | `/blog/NewDesktopDevStory` |
| 网盘授权完成 | zh-hans、zh-hant、en、ja、ko | `/<语言>/drives/oauth/<onedrive｜dropbox｜aliyun>/` | `/drives/oauth/*` |
| 404 | 各语言 | 各语言目录下的 `404.html` | — |

命名说明：

- 旧名「wiki」改为「manual」，因为它是使用手册，不是维基；旧名「warning」改为「genuine」，页面讲的是请使用正版。
- 旧的 `/privacy` 实际是 Android 版的隐私政策，正文写的都是 Android 的情况。新地址按端分开：`/android/privacy/`、`/ios/privacy/`、`/desktop/privacy/`。
- 旧地址都保留 301，所以改名不影响任何入口，代价只是旧链接多跳一次。
- `/home_en`、`/dorakito`、`/cn/` 是没有站内入口的旧首页，作用已由同语言的新首页承担，不再迁移内容，改为 301。

### 4.5 旧地址的映射规则

1. **多语言入口**：`/`、`/desktop`、`/desktop2`、`/desktop2_en`、`/desktop_en`、`/ios/privacy`、`/ios/support`，以及它们的 `.html` 写法。按以下优先级确定语言：
   1. 合法的 `?lang=`，返回 301。规范化规则沿用旧站：zh、zh-Hans、zh-CN 归简体；zh-TW、zh-Hant 归台湾繁体；zh-HK、zh-MO 归香港繁体；ja、en 开头的分别归日文、英文；ru 只对桌面页有效。识别不了的值（例如 iOS 传来的 de）按没有传处理。
   2. cookie `pw_lang`。
   3. `Accept-Language` 中第一个受支持的语言。
   4. 请求根本不带语言头（多为爬虫和检查程序）时，落到 zh-hans；带了语言头、但都不受支持时，落到 en。

   第 2～4 种情况返回 302，带 `Vary: Accept-Language, Cookie` 与 `Cache-Control: no-store`。
2. **单语言旧地址**：按 4.4 的表确定性地 301。`_zh` 一律到 zh-hant，与旧站行为一致。
3. **永不参与协商和跳转**：`/.well-known/*`、`/images/*`、`/desktop2.json`、`/ocat/jars/*`、`/robots.txt`、`/sitemap.xml`、`/llms.txt`。
4. **未知路径**：返回真正的 404（按路径前缀或协商出的语言选择 404 页），不再返回 500，也不跳回首页。
5. **零碎修正**：
   - 外部文字链接常把全角句号带进地址，例如 `/desktop2。`（52 天 189 次），按去掉句号后的地址处理；
   - 授权页的服务商名不区分大小写（日志里有小写的 `onedrive`）。

规则全部写在 `ops/caddy/Caddyfile` 里；`ops/` 下的 URL 合同检查（5.5）逐条验证这些行为。

### 4.6 网盘授权完成页

事实：

- 这些页面并不处理 OAuth 回调。授权码由 rebase-server 在 `api.drakeet.com` 上收下并存好，之后才把浏览器 307 到这里，页面只负责告诉用户「授权完成，可以回到纯纯写作」。
- 只有桌面版会走到这里：Android 和 iOS 在 App 内截获回调，不经过这些页面。

新做法：

- 每个服务商每种语言一个静态页，地址见 4.4。正文沿用旧页文字，`<html lang>` 写对，带 `noindex`。
- 修正旧页的错误：
  - Dropbox 五个页面的标题误写成「OneDrive for Pure Writer」；
  - 15 个页面的 `lang` 一律是 `en`；
  - `Aliyun_zh.html` 里残留一条带示例授权码的注释；
  - 10 秒后调用 `window.close()` 的脚本从未生效：桌面版是用系统浏览器打开授权地址的，浏览器不允许脚本关闭这类标签页。新页面去掉这段脚本，正文里如有「将自动关闭」的说法也一并去掉。
- 旧地址按后缀 301：无后缀到 zh-hans；`_en` 到 en；`_zh` 到 zh-hant；`_ja` 和 `_jp` 到 ja；`_ko` 到 ko。这样不用改 rebase-server，日文用户的 500 也就修好了。
- 可选的后续：rebase-server 直接跳到新地址，省掉一跳（第 8 步）。

### 4.7 桌面版下载页与 desktop2.json

- `data/desktop2.json` 由 release.sh 写入，构建时渲染进下载页：版本、发布日期、安装包大小、SHA-256，以及各语言的「最近更新」。页面不再在运行时读取 JSON，不开脚本也能看到完整信息，下载按钮也不会先灰着。
- 同一份文件仍发布在 `/desktop2.json`，供 release.sh 校验，也供任何外部读取方使用。缓存头是 `no-cache`。文件名里的「2」是历史遗留，保持不变。
- 「只突出适合这台电脑的安装包」改为外部脚本做的渐进增强：没有脚本时三个安装包并列显示。
- 旧页面的锚点 `#download`、`#download-en`、`#download-zh-Hant` 等，在新页面里以别名形式保留，旧链接里的锚点照样能定位。

### 4.8 静态资源

- **旧图片**：旧站 `images/` 整个目录按原路径、原字节放进 `static/images/`，不重新压缩、不改名，缓存一周。其中 7 个已经没有任何引用（`desktop2.png`、`ic_launcher.png` 等），也一并保留：总共只有 6.8 MB，而站外引用无法排查干净。
- **新页面的图片**（首页横幅、下载页截图等）走 Hugo 的图片处理：
  - 缩放到显示需要的尺寸，输出 WebP，必要时加 AVIF 并带回退；
  - 文件名带内容指纹，缓存一年并标为 `immutable`；
  - 下载页的两张截图现在合计 1.5 MB，预计缩小 80%～90%。
- **不复制的东西**：旧 Jekyll 主题的 `assets/`（字体、样式表）、根目录的 `thumbnail.png`、`CNAME`、`Gemfile` 等，都不进入新站。

### 4.9 安全、缓存、压缩与错误页

**响应头**

| 响应头 | 值 |
|---|---|
| `Content-Security-Policy` | `default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src 'self'; object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; upgrade-insecure-requests`。新站不写内联脚本和内联事件；Markdown 渲染出的 `style` 属性（例如表格对齐）用渲染钩子改成 class，实在避不开时再放宽 `style-src`。DeepOCAT 旧页单独放宽。 |
| `Strict-Transport-Security` | 上线时 `max-age=86400`，一周后改为 `max-age=31536000`。不加 `includeSubDomains` 和 `preload`：preload 要求在 drakeet.com 上设置并覆盖全部子域，牵连太广，而且很难撤销 |
| `X-Content-Type-Options` | `nosniff` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | 关闭摄像头、麦克风、定位等用不到的能力 |
| `Server` | 不暴露版本 |
| 刻意不设 | `Cross-Origin-Resource-Policy`：ocat.app 跨站引用本站图片 |

**缓存**

| 类别 | 例子 | Cache-Control |
|---|---|---|
| HTML | `/zh-hans/...` | `no-cache`（每次用 ETag 验证） |
| 带指纹的样式、脚本、图片 | `/assets/main.3f9c1a.css` | `public, max-age=31536000, immutable` |
| 旧图片（固定地址） | `/images/papers/0.jpg` | `public, max-age=604800` |
| 数据文件 | `/desktop2.json` | `no-cache` |
| 协商用的 302 | `/` | `no-store` |

**压缩与协议**

- 文本类响应由 Caddy 动态压缩（zstd、gzip）。站点的字节大头是图片，预压缩 brotli 收益有限，以后需要再加。
- HTTP/2 与 HTTP/3 默认开启；TLS 保留 1.2 与 1.3，因为 Android 6～9 只支持 1.2。

**错误页**：未知路径返回各语言的 404 页，状态码就是 404。

### 4.10 搜索引擎与 AI 的基础支持（重建中一并完成）

- 每页：
  - 正确的 `<html lang>`、标题与描述；
  - 指向自身的 canonical，以及双向互指的 hreflang，并带 `x-default`（指向协商入口）；
  - OpenGraph 与 Twitter 卡片。
- `sitemap.xml` 按语言列出全部正式地址；`robots.txt` 指向它。
- 爬虫一律放行，包括各家 AI 的检索与训练爬虫：目标就是让用户和各种服务更容易知道、搜到纯纯写作。不想被收录的页面（授权完成页、404）用 `noindex`，不在 robots.txt 里屏蔽，否则爬虫看不到 noindex。
- 首页与下载页带 JSON-LD（SoftwareApplication：各平台、价格、下载地址）。
- 根目录提供 `llms.txt`：用 Markdown 介绍产品，并给出主要文档的链接。主要文档另外输出一份 Markdown 版本（例如 `/en/manual/index.md`），方便 AI 读取干净的正文。
- 站点图标齐全：`favicon.ico`、SVG 图标、`apple-touch-icon.png`；首页保留 iOS 智能横幅的 meta。
- `/.well-known/security.txt` 写明联系邮箱；构建检查会在它的 Expires 到期前 30 天报错提醒。
- 不加任何统计脚本。需要了解访问情况时，在本机分析服务器日志。

更深入的 SEO 与 AI 可发现性工作放在第 7 步。

## 五、服务器

### 5.1 系统与迁移方式：原地「更换操作系统」为 Ubuntu 26.04 LTS

- **为什么是 26.04**：
  - 免费标准支持到 2031-05，比 24.04 多两年；
  - OpenSSH 10.2 内建了按来源惩罚（PerSourcePenalties）与后量子混合密钥交换；
  - 26.04.1 已于 2026-08 发布，「等第一个点版本」的观望期已经过去；
  - 阿里云公共镜像 2026-05 首发，至今持续更新。
- **为什么原地更换**：EIP、实例和网卡都不变，ICP 备案与公安联网备案不受影响，也不产生额外费用。代价是停机：更换约 10 分钟，加上初始化与部署，目标是 30 分钟以内。
- **为什么不就地升级系统**：从 20.04 到 26.04 要连跳三个 LTS，1 GiB 内存、没有 swap、还装着第三方源和厂商代理，风险高；而且留下五年的历史残留，违背「配置全部入库、可以重复执行」的目标。
- **为什么不新建实例再换绑 EIP**：这样能做到接近零停机，但要核实备案服务号对新实例的要求（包年包月、累计购买超过 3 个月），还要承担新旧实例并行期间的双份费用。为了省下约 30 分钟的停机，不值得。
- **演练与回滚**：
  - 切换前，在本机虚拟机里用同一个系统版本把初始化脚本、部署和 URL 合同检查完整跑通（第 3 步）；
  - 切换前做一次手动快照。万一新系统无法在合理时间内修好，就用快照制作自定义镜像，再更换一次系统回到旧机。这条路较慢，所以要靠演练尽量用不上。

### 5.2 Web 服务器：Caddy 2

单站点静态服务加上自动证书，正是 Caddy 的本职工作：

- 证书（Let's Encrypt 为主、ZeroSSL 兜底，支持 ARI 续期）、80 到 443 的跳转、HTTP/2 和 HTTP/3 都是默认行为，不再需要 certbot 和定时任务；
- 配置短，`try_files` 加 `file_server` 几行就能表达「`/x` 对应 `x.html`，找不到返回 404」，旧站的 500 循环不会再出现。

几项关键事实：

- **证书有效期**：Let's Encrypt 的证书有效期 2027-02 起缩短为 64 天，2028-02 起缩短为 45 天。Caddy 的自动续期正好覆盖这个变化。
- **安装来源**：Ubuntu 自带的 caddy 停在 2.6.2，太旧，所以用 Caddy 官方的 APT 源。2026-11-07 从这台服务器实测，官方源、Let's Encrypt、ZeroSSL 都能正常连通。
- **升级策略**：Caddy 的升级交给 unattended-upgrades 自动进行。万一新版本拒绝旧配置，由外部监控与部署检查发现。

备选方案是 Ubuntu 26.04 自带的 nginx 1.28：要另配 certbot，HTTP/3 在上游仍标为实验性。

### 5.3 目录、账户与权限

```
/srv/writer.drakeet.com/releases/<UTC 时间>-<提交>/   每次部署一份构建产物，保留最近 5 份
/srv/writer.drakeet.com/current → releases/…        Caddy 的站点根目录，切换用 mv -T 原子完成
/srv/writer.drakeet.com/jars/                        JAR 镜像，站点部署不会碰它
/etc/caddy/Caddyfile                                 来自仓库的 ops/caddy/Caddyfile
```

账户：

- **`drakeet`**：唯一的登录账户，只能用密钥登录；拥有 `/srv/writer.drakeet.com`；在 `adm` 组里，可以直接读日志。部署站点、触发 JAR 同步都用它。
- **root**：不能经 SSH 登录，只能在机器上用 `su` 切换（密码由 Drakeet 掌握），也可以在阿里云控制台的远程终端里使用。
- **重建期间的免密 sudo**：drakeet 有临时的免密 sudo，收尾时收回。收回后，改 Caddyfile、装软件这类少见的特权操作，由 Drakeet 用 `su` 执行仓库里的脚本。
- **不另设部署账户**：部署用的密钥和管理用的密钥都在同一台 Mac 上；免密 sudo 收回后，drakeet 本身就没有 root 权限。再加一个账户只增加复杂度，并不缩小暴露面。将来如果改由 CI 部署，再加一把用 `rrsync` 限定目录的专用密钥。

### 5.4 加固清单

- **SSH**：配置片段 `/etc/ssh/sshd_config.d/00-writer.conf`。文件名要排在云镜像自带的 `50-cloud-init.conf` 前面：sshd 对同一项取第一次读到的值，后者可能写着 `PasswordAuthentication yes`。
  - 内容：只接受公钥、禁止 root 登录、`AllowUsers drakeet`、关闭 X11 与代理转发；
  - 算法用 OpenSSH 10.2 的默认值；
  - 改完用 `sshd -T` 核对实际生效的设置；
  - 不装 fail2ban：只用密钥加上内建的 PerSourcePenalties，已经覆盖了它在 SSH 上的作用。
- **防火墙**：ufw 默认拒绝入站，只放行 TCP 22、80、443 和 UDP 443（HTTP/3）。80 端口不限来源，因为 ACME 验证需要。阿里云安全组建议保持同一份白名单（第十节第 6 项）。
- **自动安全更新**：
  - unattended-upgrades 安装 security 来源与 Caddy 官方源的更新；
  - 需要重启时在凌晨 04:30（上海时间）自动重启。旧机 695 天不重启、内核补丁从未生效，是这次最大的教训；
  - 装好后、以及过几天，各核对一次它确实在运行。
- **时间同步**：chrony，使用阿里云内网的多个 NTP 源（镜像默认配置），装好后核对实际时钟源。
- **日志**：
  - Caddy 访问日志用 JSON 格式，记录主机名（旧日志不记主机名，几个站点的访问混在一起），保留 183 天后删除。《网络安全法》要求网络日志留存不少于六个月；日志含访客 IP，留够期限就删。
  - journald 设上限 1 GB。
- **swap**：2 GiB 的 swapfile。1 GiB 内存正好是 Ubuntu 云镜像的最低要求，`apt` 升级时容易内存不足。
- **阿里云代理**：保留镜像自带的云助手（控制台的救援通道）、云监控、云安全中心基础版，内存吃紧时再评估。
- **精简**：卸载用不到的组件，例如镜像如果自带 snapd 又用不上。

### 5.5 监控、检查与备份

- **URL 合同检查**（`ops/` 下）：按第三节与 4.5 列出的每一条请求（路径、查询串、语言头、cookie），核对状态码、跳转目标、Content-Type，以及固定图片的字节哈希。
  - 本机：对「Caddy 加上这次的构建产物」跑一遍，作为部署前的门槛；
  - 线上：每次部署后自动跑一遍。
- **外部监控**（可选，需要 Drakeet 的控制台或账号，见第十节）：
  - 阿里云站点监控：从国内视角，每 5 分钟检查首页、`/desktop2.json` 和 AASA；
  - Red Sift Certificates Lite：证书到期提醒。Let's Encrypt 已于 2025 年停发到期邮件。
- **备份**：不需要常规备份。站点与配置都在仓库里，证书可以重签，JAR 可以从 R2 重新拉取。
- **切换前的一次性工作**：
  - 做一次手动快照，一周后删除；
  - 旧机上 52 天的访问日志拉回本机保存，以满足六个月的留存要求，到 2027-05 删除；
  - 旧机上只存在于服务器的东西（drakeet.com 的页面、个人代理的配置、nginx 配置）拉回本机存档。

### 5.6 JAR 国内镜像：由服务器从 R2 拉取

**用途**：国内有的用户连不上 Cloudflare，所以 R2（kuromi.drakeet.cn）上的桌面版 JAR 要在这台国内服务器上也放一份。rebase-server 把连不上 GitHub 的客户端里约一半的自动更新下载改写到 `https://writer.drakeet.com/ocat/jars/`，桌面版 CI 也用这个地址兜底。

**旧做法的问题**：

- 发版时由 `buildAllJars.sh` 从 Drakeet 在日本的电脑经 SFTP 上传三个包，约 127 MB；跨境链路晚上很慢；
- 上传后从不清理，已经积累了 6.5 GB。

**新做法**：

1. `buildAllJars.sh` 照旧先把 JAR 传到 R2。
2. 之后改为执行 `ssh drakeet@writer.drakeet.com writer-jars-sync <版本> <文件名>=<sha256>…`。
3. 服务器上的 `writer-jars-sync` 依次完成：
   1. 从 R2 下载三个包（2026-11-07 实测每秒 5～7 MB，三个包约半分钟）；
   2. 逐个核对 sha256；
   3. 全部通过后原子地放进 `jars/`；
   4. 只保留当前版本和上一版，删除更早的版本。保留上一版，是因为新版发布后的一天里，仍有客户端在下载上一版（5.1.0 发布后，5.0.0 还有几百次请求）。
4. 对外地址不变。rebase-server、JarVersions 模板和 CI 都不用改。

**以后可以考虑**：镜像改由阿里云 OSS 加 CDN 提供（每天约 3 GB 的出向流量），不在本轮做。

### 5.7 其他托管

- **drakeet.com 与 www.drakeet.com**：切换时先由 Caddy 继续提供备份下来的那两个静态文件（证书自动签发），保证它们不断；最终是保留、301 到 ocat.app，还是停止支持，放到第 8 步决定。DNS 上的两处问题也放到那时处理：
  - 根域名用 CNAME 指向 writer.drakeet.com，同时又有 MX 记录，不符合 DNS 规范；
  - writer2.drakeet.com 指向这台服务器，但上面没有任何站点。
- **个人代理服务**：不放进主线切换。配置先备份，切换后按需改用仍在维护的实现重新部署；在那之前，它的端口保持关闭。

## 六、构建、部署与回滚

- **工具链**：Hugo 标准版，版本固定在开工时的最新稳定版（2026-11 为 v0.169.0）。`scripts/hugo` 首次运行时从 GitHub Releases 下载指定版本、核对 SHA-256，放进本机缓存，之后每次构建都用这个版本。不需要 Node 或 npm。
- **命令**：

| 命令 | 作用 |
|---|---|
| `scripts/dev.sh` | 本机实时预览 |
| `scripts/build.sh` | 全新构建到 `public/`，再跑检查：构建警告视为错误、站内链接全部可达、本地化检查（应有的译文、台港用词、市场差异）、URL 合同检查（本机 Caddy 加这次的构建产物） |
| `scripts/deploy.sh` | 要求工作区干净、位于 `master`；构建并检查 → `rsync --link-dest` 上传到新的 release 目录（未变的文件做硬链接）→ `mv -T` 原子切换 `current` → 只保留最近 5 份 → 对线上跑 URL 合同检查；失败则报错并打印回滚命令 |
| `scripts/deploy.sh --rollback` | 把 `current` 切回上一份 |
| `ops/provision.sh` | 服务器初始化，可重复执行；需要 root |
| `ops/deploy-config.sh` | 更新 Caddyfile 等服务器配置：先 `caddy validate`，再 reload；需要 root |

- **为什么在本机构建，而不是 CI**：
  - release.sh 本来就在这台 Mac 上运行；
  - 部署凭据不用交给第三方；
  - 工具版本固定，构建可以复现。

  以后如果需要，可以加只做构建检查、不做部署的 CI。

## 七、与各端流程的衔接（切换时一并修改）

| 相关方 | 现在 | 切换后 |
|---|---|---|
| 桌面版 release.sh 的 site 步骤 | 写仓库根目录的 `desktop2.json`，提交并推送 | 改写 `data/desktop2.json`，其余不变（提交，推 gitee 与 GitHub） |
| release.sh 的 deploy 步骤 | ssh 到服务器 `git pull`，再 curl 校验 | 调用站点的 `scripts/deploy.sh`，再做同样的 curl 校验 |
| `buildAllJars.sh` | SFTP 上传到站点目录 | R2 上传不变；改为 ssh 触发服务器从 R2 拉取（5.6） |
| 桌面版 CI 的兜底下载 | `writer.drakeet.com/ocat/jars` | 不变 |
| rebase-server | JarVersions、Drives、RawJsonResource 里的地址 | 不需要改。可选：授权完成页与「检查更新」直接指向新地址，少一跳 |
| iOS 仓库文档 | `docs/privacy.md`、`fastlane/GUIDE.md` 写着 `ios/privacy.html` 和旧的部署方式 | 改成新的源文件位置（`content/ios/privacy/`）与部署命令 |
| 本机记忆「官网部署方式」 | 旧的 git pull 流程 | 重写（先请 Drakeet 确认内容） |
| 本机 `known_hosts` | 旧主机密钥 | 重装后更新 |
| GitHub 镜像仓库 | 开着 GitHub Pages（legacy Jekyll，从 master 根目录构建） | 关闭 |

## 八、过渡期安排

- **工作目录（建议，待确认）**：主目录 `/Users/drakeet/GitHub/writer.drakeet.com` 切回 `master`，新站在旁边的工作树 `/Users/drakeet/GitHub/writer.drakeet.com-rebuild`（分支 `rebuild`）里开发。理由：
  1. release.sh 的预检要求官网仓库处在 `master`，并在当前分支上提交 `desktop2.json`。主目录停在 `rebuild` 时，任何一次桌面发版都会在预检被挡下；而桌面版平均 1.6 天发一版。
  2. iOS 会话按 iOS 仓库 `docs/privacy.md` 在主目录修改隐私政策，Drakeet 的手工部署也针对主目录。
  3. 主目录如果被别的会话切换分支，正在开发中、尚未提交的新站文件会受影响；单独的工作树不会。
- **过渡期旧站的改动要带进新站**：例如桌面发版更新的 `desktop2.json`、iOS 隐私政策的修改。第 4 步对照 `git log a69f659..master` 逐项移植。
- **切换方式**：把 `rebuild` 合并进 `master`，不强推。合并时 `desktop2.json` 取 `master` 上的最新数据，放进 `data/desktop2.json`。

## 九、实施步骤与验收

1. **骨架与工具链**：Hugo 固定版本、语言配置、基础模板与样式、检查脚本骨架。
   - 验收：`scripts/build.sh` 能构建出空的多语言站点，并通过检查。
2. **内容迁移**：所有页面、所有语言，以线上 HTML 为准迁成 Markdown。sources/ 原稿与线上已有分叉的地方（`backups_zh`、`dorakito`），以线上为准。此外还要完成：
   - 使用手册的 137 个标题锚点原样保留；
   - 桌面版下载页、网盘授权完成页、404；
   - 4.10 的基础项。

   验收：
   - 逐页文本比对报告：去掉标记后，旧页与新页的正文一致，差异只来自第一节第 5 条允许的修正；
   - 站内链接全部可达。
3. **服务器配置写进仓库，并在本机演练**：
   - `ops/provision.sh`、`Caddyfile`（映射、协商、响应头）、`scripts/deploy.sh`、`writer-jars-sync`、URL 合同检查；
   - 在本机虚拟机（Ubuntu 26.04）里从空白系统跑到可以访问。

   验收：URL 合同检查全部通过。
4. **切换前准备**：
   - 移植过渡期的改动；
   - 备份服务器上独有的数据（5.5）；
   - 关闭 GitHub Pages；
   - 桌面仓库与 iOS 文档的改动准备好待合并；
   - 与 Drakeet 约定切换窗口。
5. **切换**：
   1. Drakeet：手动快照，然后「更换操作系统」为 Ubuntu 26.04，登录凭证选现有的密钥对；
   2. 运行 `ops/provision.sh`；
   3. 部署站点，同步 JAR，签发证书；
   4. 对线上跑 URL 合同检查；
   5. 更新本机 `known_hosts`；
   6. 合并桌面仓库与 iOS 文档的改动；
   7. `rebuild` 合并进 `master` 并推送。

   验收：
   - URL 合同检查全部通过；
   - 用一次 release.sh 的 `--from site` 演示，或者下一次真实发版，确认桌面发版流程畅通；
   - 停机不超过 30 分钟。
6. **上线后一周**：
   - HSTS 改为一年；
   - 核对自动更新确实运行过、证书续期正常、日志按期滚动；
   - 请 Drakeet 删除快照；
   - 提醒收回免密 sudo。
7. **SEO 与 AI 可发现性**：
   - 结构化数据与 `llms.txt` 的内容打磨；
   - 在 Google Search Console、Bing Webmaster Tools、百度搜索资源平台验证站点并提交 sitemap（需要 Drakeet 的账号，验证可以用阿里云 DNS 的 TXT 记录）；
   - 部署时通过 IndexNow 通知 Bing 等搜索引擎；
   - 各语言标题与描述的质量检查。
8. **后续**：
   - drakeet.com 与 DeepOCAT 旧页的去留；
   - 请 ocat.app 改为自己托管那 5 张图片；
   - DNS 清理；
   - rebase-server 的可选简化；
   - 补齐滞后的译文（见第十一节）；
   - 个人代理服务按需重装。

## 十、需要 Drakeet 回答或操作的事项

1. **过渡期的工作目录**：建议按第八节，主目录切回 `master`，新站在 `writer.drakeet.com-rebuild` 工作树里开发。主目录的清空提交仍在 `rebuild` 分支上，切换时合并进 `master`。
2. **允许下载以下工具**：建议同意，均为官方来源，固定版本并核对校验和。
   - Hugo：GitHub Releases，约 20～40 MB。构建必需。
   - Caddy 的 macOS 版：约 40 MB。在本机跑 Caddyfile 与 URL 合同检查。
   - Lima 与 Ubuntu 26.04 云镜像：Lima 走 Homebrew，约 30 MB；云镜像来自 cloud-images.ubuntu.com，约 700 MB。用于在本机演练服务器初始化。
   - 公安备案图标：beian.mps.gov.cn，约 2 KB。改为本站托管。
3. **页脚的备案号**：
   - 首页与桌面页挂的是「闽ICP备2021006387号-1」；
   - 旧 `/cn/` 页挂的是「苏ICP备2023014404号-1」；
   - 公安备案号是「苏公网安备32050602012178号」。

   writer.drakeet.com 现在应该挂哪个 ICP 号？建议您确认后只保留一个；确认之前，沿用首页的闽 ICP 号。
4. **切换窗口**：第 5 步需要您在阿里云控制台做两件事：先手动快照，再「更换操作系统」为 Ubuntu 26.04，登录凭证选您现有的密钥对。前后约 30 分钟，期间网站不可用。建议选国内凌晨，具体时间由您定；我准备就绪后提前通知。
5. **关闭 GitHub 镜像仓库的 GitHub Pages**：建议由我用 `gh` 关闭。它现在每次推送都按 legacy Jekyll 构建 `master`，切换后会构建失败并发邮件；DNS 并不指向它。
6. **可选**：
   - 阿里云安全组与 ufw 对齐：入方向只留 TCP 22、80、443 和 UDP 443；
   - 配置阿里云站点监控与证书到期提醒（5.5）。

## 十一、已知问题与后续（本轮不做）

- **滞后的译文**：
  - `wiki_en` 缺 16 条问答；
  - `backups_en` 停在 2023 年；
  - `wiki_zh` 是机械的简转繁，并兼作香港版；
  - `privacy_en` 缺两段；
  - `backups_zh` 落后于 sources/ 原稿。

  本轮按线上版本原样迁移，留待文案批次处理。
- **违反市场约定的旧内容**：`backups_zh`、`wiki_zh` 里有只适合大陆用户的内容。本轮原样迁移，留待文案批次处理；构建检查对这两页暂时只给提示、不拦截。
- **运营主体的写法**：各语言页面与结构化数据里的运营主体写法尚未统一（苏州小白迷雾科技有限公司、Drakeet, Inc.、ドラキート株式会社等），第 7 步与 Drakeet 确认。
- **Azure 注册里的网页回调**：注册信息里是否还留着 `https://writer.drakeet.com/drives/one` 这类从未使用过的网页回调，未核实，可以顺手清理。
