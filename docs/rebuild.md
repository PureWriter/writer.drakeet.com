# 官网重建

纯纯写作官网（writer.drakeet.com）从零重建的专项正本：目标、调研结论、URL 合同、站点架构、服务器方案、部署方式、实施步骤与验收。阶段进度只写在「当前游标」；其余各节是现役合同，实施中有变化时直接改对应小节；评审记录单独放在文末第十二节。

## 当前游标

- **第 A 步（服务器先行）**：2026-11-07 完成，执行记录见第九节 A 的末尾。
  - 服务器已是 Ubuntu 26.04 LTS 加 Caddy 2，旧站在新服务器上按版本发布，JAR 镜像已同步 4.9.1～5.1.0；现役事实与操作见 [operations.md](operations.md)。
  - 旧站 `master` 已加入 `scripts/deploy.sh` 与 `caddy/site.caddy`（847e9f9），服务器配置 `ops/` 与运维手册（d565168），以及 GitHub Actions 的外部监控（4865ac2），都已推送，并已合进 `rebuild`（7a944de）。
  - 桌面版发版脚本已改为新流程并提交（PureWriter2 cef8c041，未推送），桌面发版的冻结已解除；本机记忆「官网部署方式」已按新流程重写。
- **第 B 步（新站开发与预发）**：完成。全部页面迁入 `content/` 并与旧页逐页比对一致，站点规则、URL 合同（500 行）、部署脚本与构建检查经三轮复审（第十二节第三轮），预发站 writer2.drakeet.com 上的合同全部通过。
- **第 C 步（切换网站）**：2026-11-07 完成，执行记录见第九节 C 的末尾。线上就是新站，使用手册（第 F 步提前完成的三端重写）与按 Drakeet 意见修改的隐私政策随之上线。
- **下一步**：
  - 第 E 步：已完成并上线（第九节 E）。2026-11-12 按各搜索引擎的实际结果做了一轮跟进（第九节 E 末尾「2026-11-12 实测与跟进」）：drakeet.com 的跳转改为到本站，首页标题与描述、桌面页的「电脑版」、iOS 版介绍页与 `/ios` 入口都已上线（785d6e7，2026-11-12 部署），必应站长平台已导入本站。同一天补齐了面向 AI 的可读性（`/llms-full.txt`、`llms.txt` 补全、iOS 版介绍页的 FAQPage，见第九节 E「面向 AI 的可读性」），尚未提交与部署。要观察的事（Google 的站点名、英文首页的收录、AI 爬虫对两个文件的读取）列在那一节的末尾；
  - 博客：2026-11-13 上线第一批（2ed97ea，当天部署，合同 556 行全过，IndexNow 推送 69 个地址）：七篇文章共 23 个语言版本（简体七篇、繁体七篇、英文五篇、日文四篇），四种语言的列表页与首页入口，「请使用正版」页新增繁体、英文、日文版；约定见 [content.md](content.md) 第十节。当天在 Search Console 请求编入索引的有四个列表页、简体的使用教程与英文的正版页，其余靠列表页与 sitemap。选题依据是百度与 Google 的搜索联想词与 Search Console 的检索词；第二批同一天上线（9a69aff，合同 569 行全过，IndexNow 推送 18 个地址）：写小说用什么软件、长篇分卷分章、写日记用什么软件保密（各简体与繁体），写文章够用的 Markdown（简繁英日），网文排版（简体），不打扰的写作 App（英文与日文），共 13 个语言版本；当天在 Search Console 请求编入索引的有简体的写小说一篇与日记一篇、英文的 Markdown 一篇与不打扰一篇。这一批有几项功能手册没有写，取自三端的界面文字与代码并核实了入口与发布版本（自动章节名、Android 版的指纹锁、每日统计、导入的日记类来源），出处在各篇开头的注释里；手册补上这几项后，文章的出处可以改指手册。四篇 Markdown 文章照手册写「桌面版目前不渲染 Markdown」，桌面版的预览上线后，手册与这几篇要一起改。百度搜索资源平台 11-13 的提交配额仍是 0，手动提交仍回「今日的链接提交量已达上限」，之后由 Drakeet 自己操作；
  - 第 F 步：完成。使用手册与两份教程都已按三端现行版本重写并上线（教程 fc0b13d，GPT 复审未发现事实错误）；
  - 第 D 步在上线一周后（11-14 前后）核对；
  - 10.1 的翻新建议已全部定下：第 F 步之外的各条 2026-11-08 在 `master` 上实施完毕；正式站的部署，以及把 drakeet.com 的跳转规则装到服务器（operations.md 第 6 节），等 Drakeet 同意后进行；
  - 第九节 H（出口分流）：设计正本 [egress-offloading.md](egress-offloading.md)。2026-11-08 凌晨三端代码都已完成并经 GPT 复审（rebase-server 已合并、iMac 已部署；桌面版与 Android 本地提交、随各自发版），R2 旧图片副本已上传；api.drakeet.com 11-08 早上部署并核对通过，剩下桌面版与 Android 随各自发版，进度见那边的游标；隐私政策的其余问题记在第十一节，网站重建完成后单开一个系列。
- **仓库**：
  - 主目录 `/Users/drakeet/GitHub/writer.drakeet.com` 在 `master`，就是线上的新站；之后都在 `master` 上改、提交、推送，部署按 operations.md 5.1。
  - 重建期间的 `rebuild` 分支已在第 C 步快进进 `master`，它的工作树随后移除；旧站另有完整副本在本机 `/Users/drakeet/GitHub/writer.drakeet.com.old`。
- **收尾时必须做、不论进行到哪一步都不能漏**（Drakeet 问「所有事情都完成了吗」时逐条提出）：
  - 请 Drakeet 先给 drakeet 账户设口令，再收回重建期间的免密 sudo（5.3；安全的操作顺序见 operations.md 第 9 节）；
  - ~~请 Drakeet 在 Google Search Console 添加站点并提交 sitemap~~：2026-11-08 已添加并提交，11-12 核对读取成功（第九节 E）；
  - 请 Drakeet 考虑官网上的商店链接是否加来源参数：App Store 的 campaign 参数（pt、ct）与 Google Play 的 referrer，用来在 App Store Connect 与 Play 管理中心看到来自官网的下载，官网本身仍不加统计脚本。

## 一、目标与原则

**目标**

1. 站点架构：源文件可维护（Markdown 加少量模板），构建产物是纯静态文件，部署原子、可以一条命令回滚。
2. 本地化：每种语言一个独立地址，搜索引擎与 AI 能识别各语言版本；各语言之间的市场差异（备案号、蓝奏云、网盘切换提示等）由结构保证，不靠人记。
3. 服务器：受支持的系统、自动安全更新、自动证书、最小暴露面；全部配置写进仓库，可以重复执行。
4. 已发布的 App、服务端与外部平台依赖的地址一个不断（第三节）。
5. 文本内容沿用旧站，本轮不改写文案。只修正技术性错误，各处在对应小节写明，例如：失效的图片引用、从未生效的自动关闭脚本、写错的页面标题、港繁页里混入的两处台湾用词。

**取舍原则**

- 先问是否必须。不为假想的需求加组件；一个机制能解决的，不引入第二个。
- 已发布 App 用到的地址就是接口。路径和字节都按契约对待，不为整洁而挪动。
- 少依赖、长期稳定，优先于写法时髦。构建在存有各类签名与发布凭据的那台 Mac 上进行，依赖面越小越好。
- 失败要显式、要尽早，而且不能卡住与它无关的流程。例如部署后的检查失败要自动回滚；而一项与发版无关的检查，不应该让桌面版发版停在最后一步。

## 二、调研结论（摘要）

调研于 2026-11-07 完成，包括：9 个只读调研，服务器只读审计，52 天访问日志的聚合统计，阿里云控制台的只读查看。完整报告存在本机、不入库：`/Users/drakeet/Documents/iOS/writer/evidence/website-rebuild-2026-11/`。

### 2.1 旧站

- 面向用户的 HTML 共 44 个：
  - 手写多语言页 4 个（首页、桌面版下载页、iOS 支持页、iOS 隐私政策），一页内含五六种语言，由内联脚本选一种显示；
  - Typora 导出页 17 个，单语言，靠文件名后缀区分语言，内联主题 CSS 约占体积一半；
  - 跳转页 6 个、网盘授权成功页 15 个、DeepOCAT 双语页 2 个；
  - 另有 `desktop2.json` 与 Apple 关联域名文件。
- **git 检出直接当站点根目录**：`.git/`、`AGENTS.md`、`sources/`、Jekyll 遗留文件都能被下载。52 天内 `.git/` 被请求 7.2 万次，其中有专门的扒取工具。仓库本身是公开的，所以没有泄露额外内容，但这种部署方式不可取。
- **500 循环**：nginx 规则把一切不存在的路径改写成 `/$1.html`，形成循环、返回 500。52 天共 9.9 万次，大头是缺失的 `/favicon.ico`。
- **缺失的基础项**：没有 HTTP/2、缓存头、安全响应头、robots.txt、sitemap、hreflang、404 页。
- **语言逻辑散乱**：判断用户语言的逻辑至少散在 7 处。后缀命名也不统一：`_zh` 实指台湾繁体，并兼作香港；日文用 `_jp`。Typora 页的译文明显滞后。
- **现存故障**：
  - 日文授权页：rebase-server 给日文用户拼的授权成功页是 `*_ja`，站上的文件叫 `*_jp`，日文用户在桌面版授权网盘后看到的是 500。
  - Windows 安装包里的坏链接：约从 3.1.0 起，安装包写进「已安装的应用」的更新链接实际到达的是 `/desktop2JpAbortIfPureWriterRunningPure`（日志 26 次，全部 500）。推断是 MSI 改用 65001 代码页后字符串串到了一起，未在 Windows 上核实。存量安装改不了，只能由网站兜底。

### 2.2 服务器

- **实例**：阿里云上海 ECS，1 vCPU、1 GiB 内存、40 GB 系统盘、没有数据盘；包年包月，到期 2029-03。公网 IP 是实例自带的固定公网 IP，不是 EIP，更换系统盘不会改变它。
- **公网带宽**：原为 1 Mbps 固定带宽，2026-11-07 起 2 Mbps，并决定保持固定带宽、不改按流量计费：图片、JAR 一类资源慢一些可以接受。入方向不受这个限制，服务器从 R2 下载实测每秒 5～7 MB。
- **系统**：Ubuntu 20.04.2，标准支持已于 2025-05 结束；内核仍是 2021 年的版本，此后一直没有重启（已连续运行 695 天）；302 个待升级包，其中 224 个来自安全更新；没有自动更新。
- **Web 服务与证书**：nginx 1.24 来自已停更的 nginx.org focal 源。证书由 certbot 续期，另有一个每两个月停一次 nginx、强制续期的 root 定时任务，两套机制并存。
- **安全现状**：SSH 只接受密钥、禁止 root 登录，这一点符合要求。主机防火墙实际没有启用；安全组只放行 TCP 22、80、443，以及个人代理的 8621。
- **同机的其他服务**：drakeet.com 与 www.drakeet.com（一个只存在服务器上的 OCAT 页面），以及一个个人用的代理服务。
- **日志**：`journal` 日志不设上限，已占 3.5 GB。
- **备案**：阿里云账号下的 ICP 备案是「闽ICP备2021006387号」（个人主体），网站号为 `-1`。旧 `/cn/` 页上的「苏ICP备2023014404号-1」属于 drakeet.cn 的旧内容，与本域名无关。

### 2.3 流量（2026-09-16 至 11-07，共 175 万条请求）

- **App 拉取的图片是流量主体**：`/images/papers/*.jpg`（稿纸背景）、`/images/pro/**/*.webp`（Pro 介绍页）每个文件被请求 1 万到 11 万次，基本来自 Android。
- **页面**：`/` 6.9 万次，`/desktop2` 1.75 万次，`/desktop2.json` 1.3 万次，`/desktop` 8.4 千次，`/wiki` 4.5 千次，`/backups` 4.2 千次。
- **`?lang=` 的取值**：zh-Hans 3405 次、en 1420 次、zh-Hant 949 次、zh-HK 664 次、ja 572 次、ru 189 次，另有 zh、zh-hans 等写法。
- **`/ocat/jars/`**：52 天传出 151 GB。哪个版本被下载，取决于已部署的 rebase-server 下发哪个版本；它由 Drakeet 手动部署，常常落后好几版：10 月有一次滞后 4 天、跨 3 个版本，5.0.1 则从未被下发。

## 三、URL 合同

已发布的 App 改不了，外部平台登记的地址也不受我们控制，所以下列地址在新站必须继续响应。

- 本节写「为什么」和依赖方；逐条的请求与期望（状态码、跳转目标、Content-Type、必须出现的内容）以 `ops/contract.tsv` 为唯一正本，由检查脚本执行（5.5）。
- 三种处理方式：
  - **原样**：在原地址直接返回原内容，不经过任何跳转；
  - **301**：永久跳到新地址，除用过的 `lang` 参数外，查询串原样带上，浏览器会自动保留 `#锚点`；
  - **协商**：按语言 302 到对应语言的新地址，规则见 4.5。

| 地址 | 依赖方 | 新站处理 |
|---|---|---|
| `/.well-known/apple-app-site-association` | iOS 关联域名（webcredentials，1.0 起各版写死），Apple 的 CDN 从海外抓取 | 原样，`Content-Type: application/json`，绝不跳转 |
| `/images/papers/{0,4,5,6}.jpg` | Android 稿纸：完整 URL 存进用户设置，并随同步传到其他设备 | 原样，字节永不改变 |
| `/images/pro/{0..5}.webp`、`/images/pro/en/{0..5}.webp`、`/images/pro/(en/)PureWriterDesktop(Dark).webp` | Android Pro 介绍页、首次启动预取 | 原样 |
| `/images/icon512.png` | Android「关于」页 | 原样 |
| `/images/` 下其余旧图片，含 ocat.app 曾热链的 5 张（2026-11-08 起它自己托管），以及 2026-10-27 从首页撤下、Facebook 旧分享仍在引用的横幅 | 第三方 README；ocat.app 的 og:image、JSON-LD 与 PWA manifest；社交平台的预览 | 原样，整个目录保留 |
| `/desktop2.json` | 桌面版 release.sh 发版后的线上校验（curl 不跟随跳转） | 原样 |
| `/ocat/jars/PureWriter-<版本>-<平台>.jar`（5.3.0 之前的版本是 `PureWriter2-`） | rebase-server：客户端报告连不上 GitHub 时，约一半的自动更新下载改写到这里；桌面版 CI 的兜底下载 | 原样（文件放在站点目录之外，见 5.6） |
| `/`、`/index`、`/index.html`（含 `?lang=` 与 `#ios-*` 等锚点） | Android「需要更新」对话框、iOS 示例文章、App Store 营销网址、外部链接 | 协商；`?lang=` 合法时 301 |
| `/desktop`、`/desktop.html`（含 `?lang=` 与 `#download-*`） | Homebrew、Scoop、AUR 等包管理器的清单、Android 文案 | 协商 |
| `/desktop2`、`/desktop2_en`、`/desktop_en`，以及 `/desktop2JpAbortIfPureWriterRunning…`、`/desktop2_enJpAbortIfPureWriterRunning…` | 已安装桌面版的「检查更新」、Windows「已安装的应用」里的链接（后两种写法见 2.1）、rebase-server、Android 文案、winget 清单 | 协商（这几个旧地址本来就不带语言） |
| `/desktop2_zh`、`/desktop_zh` | rebase-server 与 Android 繁体文案，台湾与香港用户都会用到 | 只在 zh-hant 与 zh-hk 两者之间协商 |
| `/desktop2_ru` | rebase-server、俄语用户的通知 | 301 到俄文桌面页 |
| `/ios/privacy`、`/ios/support`（含 `?lang=`，可能是 iOS 30 种界面语言中的任何一种） | iOS App 内链接；App Store Connect 的隐私政策网址与支持网址 | 协商；`?lang=` 是页面支持的语言时 301，其余视为没有传 |
| `/wiki`、`/wiki_zh`、`/wiki_en` | Android 帮助入口（按地区分别打开） | 301 到对应语言的使用手册 |
| `/backups`、`/backups_zh`、`/backups_en` | Android 备份教程入口（`_zh` 与 `_en` 是 2019—2023 年的版本在用）、外部 README | 301 |
| `/warning` | Android 检测到篡改时打开的提示页，存量极大 | 301 |
| `/privacy`、`/privacy_en`、`/privacy_individual` | 应用商店与 Google OAuth 同意屏幕很可能登记了前两个（仓库里无法核实）；第三个是 2023 年给华为用过的旧地址 | 301 到 Android 隐私政策 |
| `/home_en` | Google OAuth 同意屏幕登记的应用首页（据旧页正文） | 301 到英文首页 |
| `/blog/NewDesktopDevStory` | 桌面版菜单（非中文界面） | 301 |
| `/d/privacy`、`/desktop/privacy` | 桌面版隐私政策（消费方未核实）；后者是 2024-12 的旧地址 | 301 |
| `/drives/oauth/{OneDrive,Dropbox,Aliyun}` 加 `_en`、`_zh`、`_ja`、`_ko`、`_jp` 后缀，服务商名不区分大小写 | rebase-server 在桌面版授权完成后 307 过来的落地页 | 内部重写到每家网盘唯一的完成页，不跳转（4.6） |
| `/markdown`、`/protections` | 站内链接、外部 README | 301 |
| `/dorakito`、`/cn`、`/cn/`、`/cn/index(.html)` | 没有站内入口的旧首页（日文版、drakeet.cn 的旧内容） | 301 到对应语言的首页 |
| `/ocat/ocat`、`/ocat/privacy`、`/ocat/terms`（含 `.html`） | 2025-03 的 DeepOCAT 页面，没有任何仓库引用，日志里只有零星访问 | 301 到 OCAT 的官网 ocat.app 上对应的页面（首页、`/privacy`、`/terms`），页面从本站删除（5.7） |
| `/v28`、`/v28.1`，有无尾斜杠均可 | 已停用的临时下载页；官方 Telegram 频道的旧消息链接着 `/v28.1` | 301 到首页 |
| `/about`、`/pro` | Android 清单里未经验证的网页链接（没有 autoVerify） | 301 到首页 |
| 所有旧页面的 `.html` 写法；旧入口名后面带着全角标点、不换行空格、右括号、反引号、星号、波浪线、方括号或单个尾斜杠 | 旧 nginx 规则；外部文字链接与 AI 回答里截断不干净的地址（例如 `/desktop2。` 52 天 189 次，多来自 Bing） | 301 到干净的旧入口，再按本表处理 |
| `http://` 下的任意路径 | 外部旧链接 | 308 到 https 的同一路径（Caddy 默认行为），再按本表处理 |

- **不规范的写法**：多余的斜杠与 `.`、`..` 段按清理后的路径处理，与规范写法一样一步到位（日志 52 天里 `//wiki` 40 次、`//` 13 次）；带语言前缀的新地址后面粘着同样的杂字符时，也 301 到干净的新地址（4.5）。
- **不安全的路径**：站点规则里，解码后含反斜杠或 ASCII 控制字符的路径一律回 400（`http://` 的请求先由 Caddy 自动 308 到 https 的同一路径，再按站点规则处理）。Caddy 补斜杠、去斜杠的默认跳转会把反斜杠与制表符原样写进 Location，浏览器把 `/\` 当成 `//`、删掉制表符，就成了跳到站外的地址。
- **新站不再提供仓库文件**：`.git/`、`sources/`、`AGENTS.md`、Jekyll 主题文件、`assets/` 等，一律返回 404。
- **自定义 scheme**：`www://writer.drakeet.com/...` 是 OneDrive 授权回调和 App 内路由用的自定义 scheme，请求不会到达网站，与本站无关；但这串地址在 App 和 Azure 的注册信息里都不能改。

## 四、站点架构

### 4.1 站点生成器：Hugo（标准版，固定版本）

候选有四个：Hugo、Astro、Eleventy，以及不用生成器、手写 HTML 加一个小脚本。选 Hugo，理由如下：

1. **内容形态匹配**。本站约 15 类页面，以长篇文字为主，各页覆盖的语言各不相同。Hugo 原生的多语言模型按页面对应译文，hreflang 和语言切换器可以由译文集合自动生成。继续手写多语言 HTML，正是旧站各语言版本漂移的根源。
2. **依赖最少**。单一二进制，不需要 Node、npm 和任何第三方包。Astro 7 的核心会拉进约 255 个 npm 包，把依赖面带到存有发布凭据的那台 Mac 上；Eleventy 正处在更名与 v4 长期停在 alpha 的过渡期。
3. **长期稳定**。版本固定后可以一直用下去；弃用的功能先提示 15 个次版本才会报错，升级可以按计划进行。

代价是 Go 模板的可读性。缓解办法是模板少而短，复杂逻辑放进 partial 并加中文注释。Hugo 的几项默认行为与本站不符，在 4.2 显式关掉。

URL 布局、重定向、语言协商与部署都写在 Web 服务器配置与脚本里，不依赖生成器的私有行为。例如不用生成器的 meta refresh 别名做重定向。这样以后即使换生成器，URL 也不用动。

### 4.2 仓库结构

```
AGENTS.md            站点约定（含市场差异规则），CLAUDE.md 引用它
docs/rebuild.md      本文
docs/operations.md   运维手册：部署、回滚、加跳转规则、查日志、从零重建服务器
hugo.toml            站点配置：语言、输出格式、Markdown 选项、关掉用不到的页面类型
content/             页面：一个页面一个顶层目录（扁平的叶子包），每种语言一个文件
layouts/             模板（含覆盖 Hugo 内置的 head、sitemap 模板）
assets/              样式表与脚本（经 Hugo 处理，输出带指纹的文件名）
i18n/                界面文字（导航、页脚、按钮等），每种语言一个文件
static/images/       旧站全部图片，按原路径原样发布
static/.well-known/  apple-app-site-association
static/llms.txt      手写的产品介绍与主要链接（根目录的 llms-full.txt 由模板生成，见 4.10）
static/indexnow.txt  IndexNow 的密钥文件（第九节 E）
desktop2.json        桌面版发版数据，由桌面版 release.sh 写入；路径与旧站相同
caddy/site.caddy     本站的 Caddy 站点规则，随每次部署一起发布（5.3）
ops/                 服务器初始化、全局 Caddyfile、服务器端脚本、URL 合同表与检查脚本、期望产物清单
scripts/             构建、预览、检查、部署与回滚
```

几点说明：

- **扁平的叶子包**。Hugo 的叶子包里不能再嵌套页面，顶层目录默认会生成列表页。所以每个页面都是一个顶层目录（例如 `content/ios-privacy/`），嵌套的 URL 用 front matter 的 `url` 表达（例如 `url: ios/privacy/`），由 Hugo 加语言前缀。
- **关掉用不到的页面类型**：分类与标签页、RSS、各目录的列表页、俄文首页都不输出。
- **博客列表页不是 Hugo 的目录列表页**：各目录的列表页仍然关着，`/<语言>/blog/` 是内容适配器 `content/blog/_content.gotmpl` 生成的普通页面，只在这种语言有博客文章时生成（4.4）。
- **期望产物清单**：`scripts/build.sh` 把 `public/` 下生成的文件与入库的 `ops/expected-files.txt` 比对，多一个、少一个都报错。这样新站的地址空间严格等于本文的约定，Hugo 自作主张多生成的页面也能当场暴露。
- **`desktop2.json` 留在仓库根目录**，路径与旧站完全相同：
  - 桌面版 release.sh 的 site 步骤因此一行都不用改；
  - 过渡期把 `master` 合进 `rebuild` 时也不会冲突；
  - 模板在构建时读取它渲染下载页，构建脚本再把它原样复制到产物根目录。
- **设计型页面直接用 HTML 内容文件**。首页与下载页的旧 HTML 里有精心排版的结构（例如标记 iOS 独有功能的 `<sup class="ios">`、SVG 图标、分组），所以用 Hugo 的 `.html` 内容文件几乎原样迁入；长文页面用 Markdown。
- **视觉**：沿用 2026-09 以来手写页的风格，即系统字体栈、跟随深浅色、配色克制、正文限制行宽；Typora 页并入同一套样式表。不引用任何外部字体和第三方资源，备案图标改为本站托管。

### 4.3 本地化组织

**URL：所有语言都带前缀；`/` 等多语言入口只做协商；单语言旧地址按 4.4 确定性 301。**

- 正式地址是 `/<语言>/<页面>/`，例如 `/zh-hans/desktop/`、`/en/manual/`。带前缀的地址永不自动跳转。
- 另一种方案是简体中文不带前缀、其他语言带前缀。没有选它，理由：
  1. 旧的多语言入口（`/`、`/desktop`、`/ios/privacy`）现在都会按访客语言显示。App Store 的审核员和外国用户需要看到英文，iOS App 也会带上 `?lang=`。简体中文若占用无前缀地址，这些入口就会固定显示中文。
  2. 所有语言都带前缀，结构对称，模板与重定向规则都更简单。

**语言键**：沿用 iOS App 与 `desktop2.json` 已有的那套，URL 里用小写。

| 语言 | URL 段 | hreflang | html lang | og:locale | 旧后缀 |
|---|---|---|---|---|---|
| 简体中文 | `zh-hans` | `zh-Hans` | `zh-Hans` | `zh_CN` | 无后缀 |
| 繁体中文（台湾） | `zh-hant` | `zh-Hant` | `zh-Hant-TW` | `zh_TW` | `_zh` |
| 繁体中文（香港） | `zh-hk` | `zh-HK` | `zh-Hant-HK` | `zh_HK` | 无 |
| 英文 | `en` | `en`，同时作为 `x-default` | `en` | `en_US` | `_en` |
| 日文 | `ja` | `ja` | `ja` | `ja_JP` | `_jp`（以及 rebase-server 拼的 `_ja`） |
| 俄文（仅桌面版下载页） | `ru` | `ru` | `ru` | `ru_RU` | `_ru` |

- **hreflang 与 og:locale 由一个 head partial 统一输出**，取值来自 `hugo.toml` 里每种语言的参数。不用 Hugo 内置模板的输出：内置模板会把 html lang 的取值（例如 `zh-Hant-TW`）原样当作 hreflang，与本表不一致。
- **只有繁体（台湾）版本、没有香港版本的页面**（例如使用手册），hreflang 标 `zh-Hant`，香港用户也会匹配到它，不另做重复页面。
- **html lang 的写法**：用 `zh-Hant-TW`、`zh-Hant-HK` 这种带文字代码的写法，CSS 的 `:lang(zh-Hant)` 能同时匹配台湾与香港，繁体字体规则只需写一次。
- **x-default 指向该页的英文版**；没有英文版的页面不写 x-default，只有一种语言的页面不输出 hreflang。之所以不指向协商入口：Googlebot 抓取时不带语言头，在入口处会落到简体中文页；那样一来，所有「没有匹配语言」的搜索者在结果里看到的都是中文摘要。

**源文件**：每个页面一个目录，每种语言一个文件，例如 `content/manual/index.zh-hans.md`、`index.zh-hant.md`、`index.en.md`。同一页面的各个译文放在一起，便于对照和审阅。

**市场差异由结构保证**：

- 备案号只由页脚 partial 在简体中文的语言参数里取到时才输出，居中显示（《非经营性互联网信息服务备案管理办法》要求在主页底部中央标明）；
- 蓝奏云、360、网盘切换提示一类只适合大陆的内容，只写在简体中文文件里；
- 构建检查扫描的是 `public/` 下的产物（包括页面里的 JSON-LD 与根目录的 `llms.txt`、`llms-full.txt`），按所在语言目录判定市场，根目录产物按非大陆处理；
- 禁用词组写成仓库里的数据文件，逐组注明适用范围与豁免。法律页面与网盘授权完成页只豁免「网盘名称、地区称谓」这一组；备案、蓝奏云、国内下载、360 各组都不豁免；
- 「阿里云盘」作为支持的网盘之一可以出现在各语言里（与 iOS App 一致），禁止的只是旧约定所说的网盘之间的切换提示和那张中文截图；
- iOS 隐私政策拆成每种语言一个文件后，检查各语言的「更新日期」一致，代替旧站同页五语带来的同步约束。

**台港用词检查**：沿用 iOS 仓库的对照表，对新写与改动的页面拦截。原样迁移的两份旧繁体文本（使用手册、备份教程）列入「旧版」名单，只提示、不拦截，等文案批次处理后从名单删除。这份名单与第十一节的市场例外放在同一处。

**语言切换器**：

- 固定列出五种核心语言：本页有该语言译文的，指向译文；没有的，指向该语言的首页；
- 俄文只在本页有俄文译文时列出；
- 普通链接，不用 `<select>`，不需要脚本。

### 4.4 页面与新地址

| 页面 | 现有语言 | 新地址 | 旧地址 |
|---|---|---|---|
| 首页 | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/` | `/`、`/index(.html)`、`/home_en`（英）、`/dorakito`（日）、`/cn/`（简） |
| 桌面版下载 | 同上，加 ru | `/<语言>/desktop/` | `/desktop`、`/desktop2*`、`/desktop_*` |
| 使用手册 | zh-hans、zh-hant、en | `/<语言>/manual/` | `/wiki`、`/wiki_zh`、`/wiki_en` |
| 自动备份与云备份教程 | zh-hans、zh-hant、en | `/<语言>/backups/` | `/backups`、`/backups_zh`、`/backups_en` |
| Markdown 教程 | zh-hans | `/zh-hans/markdown/` | `/markdown` |
| 保护机制 | zh-hans | `/zh-hans/protections/` | `/protections` |
| 请使用正版 | zh-hans、zh-hant、en、ja（后三种 2026-11-13 新增，面向搜索「mod apk」「破解版」的读者；`/warning` 仍只跳到简体页） | `/<语言>/genuine/` | `/warning` |
| Android 隐私政策 | zh-hans、en | `/<语言>/android/privacy/` | `/privacy`、`/privacy_en`、`/privacy_individual` |
| iOS 版介绍（2026-11-12 新增） | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/` | `/ios`（不是旧地址：新增的不带语言的入口，对外张贴用） |
| iOS 隐私政策 | zh-hans、zh-hant、zh-hk、en、ja | `/<语言>/ios/privacy/` | `/ios/privacy` |
| iOS 支持 | 同上 | `/<语言>/ios/support/` | `/ios/support` |
| 桌面版隐私政策 | en | `/en/desktop/privacy/` | `/d/privacy`、`/desktop/privacy` |
| 新桌面版开发故事 | en | `/en/blog/new-desktop-dev-story/` | `/blog/NewDesktopDevStory` |
| 博客文章（2026-11-13 新增） | 各篇不同 | `/<语言>/blog/<slug>/` | — |
| 博客列表页（2026-11-13 新增） | 有博客文章的语言 | `/<语言>/blog/` | — |
| 网盘授权完成 | 每页五种语言并列（4.6） | `/drives/oauth/<onedrive｜dropbox｜aliyun>/` | `/drives/oauth/*` |
| 404 | 各语言，另有一份根目录的多语言版 | 各语言目录下的 `404.html`、根目录 `404.html` | — |

**命名与取舍**：

- 旧名「wiki」改为「manual」，因为它是使用手册，不是维基；「warning」改为「genuine」，页面讲的是请使用正版。旧地址都保留 301，改名不影响任何入口，代价只是旧链接多跳一次。
- 旧的 `/privacy` 实际是 Android 版的隐私政策，正文写的都是 Android 的情况，所以新地址按端分开：`/android/privacy/`、`/ios/privacy/`、`/desktop/privacy/`。
- `/home_en`、`/dorakito`、`/cn/` 是没有站内入口的旧首页，作用已由同语言的新首页承担，不再迁移内容，改为 301。
- 博客（2026-11-13 新增）：文章是 `content/blog-<slug>/` 下的普通页面，地址 `/<语言>/blog/<slug>/`，与早先的开发故事同在 `/<语言>/blog/` 下。列表页 `/<语言>/blog/` 由内容适配器 `content/blog/_content.gotmpl` 生成，只在这种语言有博客文章时存在，不靠人记着增删；首页的入口与文章末尾的链接在列表页不存在时不输出。不带语言前缀的 `/blog/` 不是旧地址、没有依赖方，不做协商，照常 404。写法见 [content.md](content.md) 第十节。站点规则不用改：带语言前缀的地址本来就由 file_server 直接提供，粘着杂字符的写法也已由第 3 段清理。

**旧锚点的保留**：

- 各语言首页保留本语言的旧锚点作为别名，例如简体的 `#ios`、`#download`，英文的 `#ios-en`、`#download-en`；
- 下载页保留 `#download-*`；
- 使用手册三种语言的标题锚点（简体 137、繁体 137、英文 108 个）原样保留。英文的写法是 Typora 生成的，迁移时逐个写进标题属性。

### 4.5 旧地址的映射规则

**语言规范化**（`?lang=`、`Accept-Language` 的每个标签共用同一个函数）：

1. 转小写，把 `_` 换成 `-`。
2. 以 `zh` 开头的，按顺序判断：含 `-hans` 归 zh-hans；含 `-hk` 或 `-mo` 归 zh-hk；含 `-hant` 或 `-tw` 归 zh-hant；其余归 zh-hans。例如 `zh-Hant-HK` 归香港，`zh-Hans-HK` 归简体。
3. 以 `ja`、`en` 开头的，各归本语言；以 `ru` 开头的归俄文。
4. 其余视为没有提供。

合同检查用日志里出现过的真实取值（如 `zh`、`zh-hans`、带尾巴的 `zh-Hans]…`）和 iOS 的 30 种界面语言做用例。

**多语言入口的协商**：适用于 `/`、`/index`、`/desktop`、`/desktop2`、`/desktop2_en`、`/desktop_en`、`/ios`、`/ios/privacy`、`/ios/support`，以及它们的 `.html` 写法与 2.1 所说的安装包坏链接。

1. `?lang=` 规范化后是目标页面支持的语言：301 到该语言，去掉 `lang` 参数，其余参数照带。
2. 否则按 `Accept-Language` 的顺序逐个规范化，取第一个目标页面支持的语言。这一步不解析 q 值，与旧站一致；目标页没有的语言直接跳过，看下一个。
3. 请求根本不带语言头时（多为爬虫和检查程序），落到 zh-hans；带了语言头、但都不受支持时，落到 en。

第 2、3 步返回 302，带 `Vary: Accept-Language` 与 `Cache-Control: no-store`。

**`lang` 参数的口径**：取原始查询串里第一个 `lang=…` 的值，不解码；有多个时以第一个为准，与旧站脚本一致。不解码不影响真实取值：iOS、Android 与外部链接写的都是字面的短横与下划线，日志里粘着尾巴的 `zh-Hans%60` 只是尾巴被编码。301 与 302 都去掉这一个 `lang` 参数（带语言前缀的页面不看它，留在地址里只会让人误以为它起了作用），紧挨着它的 `&` 一并去掉，其余参数的顺序与写法原样保留。

`/desktop2_zh`、`/desktop_zh` 用同一套规则，只是候选语言限定为 zh-hk 与 zh-hant，默认 zh-hant。

**单语言旧地址**：按 4.4 的表确定性地 301。`_zh` 到 zh-hant，与旧站一致；网盘授权页例外，见 4.6。

**301 的缓存**：先带 `Cache-Control: max-age=86400`，稳定一两个月后再加长。这样写错的映射修正后，最多一天就从用户浏览器里消失。

**永不参与协商和跳转**：`/.well-known/*`、`/images/*`、`/desktop2.json`、`/ocat/jars/*`、`/robots.txt`、`/sitemap.xml`、`/llms.txt`、`/llms-full.txt`、`/indexnow.txt`。唯一的例外是 Caddy 的规范化：文件写成带尾斜杠的地址时（例如 `/desktop2.json/`），file_server 308 到不带斜杠的写法，与目录补斜杠对称。没有依赖方这样请求，AASA 等文件的正式地址不受影响。

**未知路径**：返回真正的 404，不再返回 500，也不跳回首页。带语言前缀的路径（包括 `/ru` 这样只有前缀的）用该语言的 404 页，其余一律用根目录那份多语言 404 页，不在错误处理里做协商。

**清理杂字符的规则**：排在「永不参与」之后。已知旧入口名后面紧跟的非路径字符或单个尾斜杠，一律 301 到去掉尾巴的旧入口。字符类见第三节最后一行；字母、数字、点和下划线不在其中，所以 `/desktop2.json`、`/desktop2_en` 不会被误伤。

带语言前缀的新地址同样清理：上线后 AI 回答与中文正文里会出现 `/zh-hans/desktop/。` 这类地址，旧地址已有同样的需要（`/desktop2。` 52 天 189 次）。语言前缀加若干段（只含小写字母、数字与短横）、可带一个尾斜杠，后面紧跟同一个字符类的，301 到「前缀加这些段」再补上尾斜杠，查询串原样带上，缓存一天。不判断目标是否存在：不存在时跳过去照样是 404。点不算段里的字符，所以 `/zh-hans/sitemap.xml。` 这类文件地址不清理。

**不安全的路径**：站点规则的第一条，在其余规则之前按解码后、未清理的路径判断，含反斜杠或 ASCII 控制字符（0x00–0x1F、0x7F）的回 400。`http://` 的请求不经站点规则，先由 Caddy 自动 308 到 https 的同一路径，再按这条处理。file_server 的规范化跳转用原始的解码路径拼 Location；Go 的跳转函数只清理 `?` 之前的部分，地址里有控制字符、无法解析时整个不清理；浏览器又把 `/\` 当成 `//`、删掉地址里的制表符。例如 `/%5Cexample.invalid/%3F%2F..%2F..%2Fen` 会得到 `Location: /\example.invalid/?/../../en/`（编码过的 `?` 让 `..` 落在不清理的那一半），`/%09/example.invalid/../../en` 得到的 Location 里是原样的制表符，浏览器都会跳到 example.invalid。实测的载体是反斜杠与制表符，其余控制字符一并拒绝，规则简单，正常的地址里也不会有它们。不能按清理后的路径判断：清理会把含这些字符的那一段连同 `..` 一起消掉。

**唯一正本**：以上规则全部写在 `caddy/site.caddy` 里，`ops/contract.tsv` 逐条验证。

### 4.6 网盘授权完成页

**事实**：

- 这些页面并不处理 OAuth 回调。授权码由 rebase-server 在 `api.drakeet.com` 上收下并存好，之后才把浏览器 307 到这里，页面只负责告诉用户「授权完成，可以回到纯纯写作」。
- 只有桌面版会走到这里：Android 和 iOS 在 App 内截获回调，不经过这些页面。
- 52 天里韩文页共 35 次访问，日文页因为 `_ja`、`_jp` 错位一直是 500。

**新做法**：每家网盘只做一个完成页，地址固定为 `/drives/oauth/<onedrive｜dropbox｜aliyun>/`，与 `/desktop2.json`、`/images/` 一样，作为有据可查的不带语言前缀的例外。

- **正文**：旧站五个语言版本（简体、繁体、英文、日文、韩文）并列，每段带自己的 `lang` 属性。迁移时文本不改，只是排版合并；英文与韩文原是机翻腔（「Please return to Pure Writer client on your own」「자체적으로 … 돌아가십시오」），2026-11 重译成自然、简短的说法（10.1 第 4 条）。
- **为什么合并**：这是一闪而过的确认页，用户一眼就能找到自己的语言；不再为 3 个页面引入一整套韩文站点语言，15 个文件变成 3 个，也不需要任何语言判断。
- **旧地址的处理**：所有旧写法（无后缀、`_en`、`_zh`、`_ja`、`_jp`、`_ko`、`.html`、服务商名大小写不同）用一条规则内部重写到对应的完成页，不跳转。rebase-server 永远不用改，日文用户的 500 也就修好了。
- **顺手修正的旧错误**：
  - Dropbox 五个页面的标题误写成「OneDrive for Pure Writer」；
  - 页面的 `lang` 一律是 `en`；
  - `Aliyun_zh.html` 残留一条带示例授权码的注释；
  - 10 秒后调用 `window.close()` 的脚本从未生效：桌面版用系统浏览器打开授权地址，浏览器不允许脚本关闭这类标签页。去掉这段脚本，正文里如有「将自动关闭」的说法一并去掉。
- 页面带 `noindex`，不进 sitemap。

### 4.7 桌面版下载页与 desktop.json

- 构建时读取仓库根目录的 `desktop.json`，渲染进下载页：版本、发布日期、安装包大小、SHA-256，以及各语言的「最近更新」。页面不再在运行时读取 JSON，不开脚本也能看到完整信息。sitemap 里这一页的 lastmod 取 JSON 里的发布日期。
- 同一份文件原样发布在 `/desktop.json`，供 release.sh 校验与外部读取，缓存头为 `no-cache`。它原来叫 `desktop2.json`，桌面版改名为 Pure Writer 时（桌面仓库 `docs/rename-to-pure-writer.md`）一起改了；旧地址 `/desktop2.json` 上放同一份内容的副本，留给仍在读旧地址的外部读取方。本文其余各处提到的 `desktop2.json` 是改名之前的写法。
- 「只突出适合这台电脑的安装包」改为外部脚本做的渐进增强，没有脚本时三个安装包并列显示。这是全站唯一的脚本。

### 4.8 静态资源

- **旧图片**：旧站 `images/` 整个目录按原路径、原字节放进 `static/images/`，不重新压缩、不改名，缓存一周。还要从 git 历史取回两张图：
  - 2026-10-27 撤下的首页横幅 `86e2ff85gy1gqlo1gmetxj21kw0rs46f.jpg`：此后 11 天仍被请求 561 次，主要来自 Facebook 旧分享的预览；
  - 已无引用的 7 张旧图（`desktop2.png`、`ic_launcher.png` 等）也一并保留：总共只有 6.8 MB，而站外引用无法排查干净。
- **新页面的图片**（首页横幅、下载页截图等）走 Hugo 的图片处理：
  - 缩放到显示需要的尺寸，输出 WebP，必要时加 AVIF 并带回退；
  - 文件名带内容指纹，缓存一年并标为 `immutable`；
  - 下载页的两张截图现在合计 1.5 MB，预计缩小 80%～90%。在 2 Mbps 的带宽下这一项收益很直接。
- **站点图标**：`favicon.ico`、SVG 图标、`apple-touch-icon.png`，外加同内容的 `apple-touch-icon-precomposed.png`（日志里 52 天 797 次）。
- **不复制的东西**：旧 Jekyll 主题的 `assets/`、根目录的 `thumbnail.png`、`CNAME`、`Gemfile` 等都不进入新站。

### 4.9 安全、缓存、压缩与错误页

**响应头**

| 响应头 | 值 |
|---|---|
| `Content-Security-Policy` | `default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; upgrade-insecure-requests`。脚本从严；样式允许内联：本站没有用户输入，禁止内联样式的收益小于它带来的定制工作（Markdown 表格对齐、代码高亮都会输出 style 属性）。 |
| `Strict-Transport-Security` | `max-age=31536000`。不加 `includeSubDomains` 和 `preload`：preload 要求在 drakeet.com 上设置并覆盖全部子域，牵连太广，而且很难撤销 |
| `X-Content-Type-Options` | `nosniff` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | 关闭摄像头、麦克风、定位等用不到的能力 |
| `Server` | 不暴露版本。80 端口到 https 的自动跳转由 Caddy 在站点规则之外完成，那个 308 带不含版本号的 `Server: Caddy` |
| 刻意不设 | `Cross-Origin-Resource-Policy`：ocat.app 曾跨站引用本站图片（2026-11-08 起自己托管），旧的缓存页面与别处的引用可能还在 |

**缓存**

| 类别 | 例子 | Cache-Control |
|---|---|---|
| HTML | `/zh-hans/...` | `no-cache`（每次用 ETag 验证） |
| 带指纹的样式、脚本、图片 | `/css/main.min.<指纹>.css` | `public, max-age=31536000, immutable` |
| 旧图片（固定地址） | `/images/papers/0.jpg` | `public, max-age=604800` |
| 数据文件 | `/desktop2.json` | `no-cache` |
| JAR 镜像 | `/ocat/jars/PureWriter2-5.1.0-Windows-x64.jar` | `public, max-age=86400`（按版本命名，内容不变） |
| 协商用的 302 | `/` | `no-store` |
| 旧地址的 301，含清理杂字符的 301 | `/wiki` | `max-age=86400`（4.5） |
| 补斜杠或去斜杠的 308 | `/zh-hans`、`/images/papers/0.jpg/` | 沿用该路径的缓存头：带语言前缀的目录等是默认的 `no-cache`；`/images/`、带指纹的文件与 JAR 下的是各自的长缓存，跳转指向的是同一个不变的文件 |
| 错误响应（404、405、412、416 等） | `/no-such-page` | `no-store` |

错误响应一律 `no-store`：出错之前按路径设好的长缓存头（图片一周、JAR 一天、带指纹的一年）不能沿用到错误上。例如 JAR 同步上来之前的 404 不能被缓存一天，修好的地址要立刻生效；浏览器不存 404，也就不会拿它来做条件验证。412（条件不满足）与 416（范围越界）由 Go 的文件服务直接写出、不经错误处理，所以站点规则另用一条按响应状态匹配的 header，把 4xx、5xx 的缓存头统一改成 `no-store`。

**压缩**：构建时为文本类产物预先生成 brotli 与 gzip 两份压缩文件，Caddy 按浏览器支持直接发送，其余情况动态压缩（zstd、gzip）。在 2 Mbps 下，HTML 用 brotli 能比 gzip 再小约 20%。brotli 工具缺失时只跳过预压缩、不让构建失败；所以合同对浏览器式的 `Accept-Encoding` 同时接受 br 与 gzip，部署不因构建机缺 brotli 而失败。

**协议**：HTTP/2 与 HTTP/3 都开（安全组已放行 UDP 443）；TLS 保留 1.2 与 1.3，因为 Android 6～9 只支持 1.2。

**错误页**：
- 404 见 4.5，状态码就是 404。404 页总是完整发送，不受请求里的 Range 与条件头影响：Caddy 发送错误页时照常处理它们，会得到半截页面或没有正文的 404，所以站点规则先把它们去掉。发送 404 页的 file_server 也关掉了规范化跳转，否则不存在的 `/x/404.html/` 会得到 308 而不是 404；
- 其余进入兜底错误处理的错误（例如对文件用 POST 得到的 405、不安全路径的 400）只回一行纯文本，`no-store`。412、416 由 Go 的文件服务直接写出、不经错误处理，没有这行文字（412 没有正文，416 是 Go 自带的一行说明），但同样是 `no-store`（见上面「缓存」）。

### 4.10 搜索引擎与 AI 的基础支持（重建中一并完成）

- **每页的元信息**：
  - 正确的 `<html lang>`、标题与描述；
  - 指向自身的 canonical，以及按 4.3 输出的 hreflang；
  - OpenGraph 与 Twitter 卡片。
- **`sitemap.xml`**：覆盖 Hugo 内置模板，只列正式地址，不写 `xhtml:link`（页头已经足够）；带 noindex 的页面不列入。`robots.txt` 指向它。
- **爬虫一律放行**，包括各家 AI 的检索与训练爬虫：目标就是让用户和各种服务更容易知道、搜到纯纯写作。`User-agent: *` 放行即可，不必逐家列出。不想被收录的页面（授权完成页、404）用 `noindex`，不在 robots.txt 里屏蔽，否则爬虫看不到 noindex。
- **结构化数据（JSON-LD）**：
  - 所有语言的首页放同一份 WebSite 数据（站点名与别名），用来控制搜索结果里显示的站点名。站点名是「纯纯写作」，别名依次是 Pure Writer、純純寫作、純純執筆，写在 `hugo.toml` 的 `siteNames`。Google 每个域名只取一个站点名、不按语言区分，根地址按语言跳转时按跳转的目标读取；
  - 首页、下载页与 iOS 版介绍页再放 SoftwareApplication，写名称、别名、平台、类别、地址与下载地址（iOS 版写 App Store 的安装地址）。价格只在能逐平台写准时才写：iOS 是试用后付费解锁，Android 是免费加内购。发行方不写：软件应用的富媒体结果需要价格与评分，没有它们，写上发行方也不改变展示；
  - 博客文章放 BlogPosting（标题、描述、发布与修改日期、语言、本页地址、站点图标）。作者与发布者写本语言的站点名，不写公司：各市场的运营主体不同，站点名是读者在页面上看到的、各市场都成立的名字；有署名的文章（开发故事）作者写本人。正文有「常见问题」一节时另放 FAQPage，取法与 iOS 版介绍页相同（`layouts/partials/faq-page.html` 两处共用），这一节可以没有；Open Graph 另写 `article:published_time` 与 `article:modified_time`。博客列表页的 og:type 与首页一样是 website；
  - iOS 版介绍页另放 FAQPage（五种语言）：模板从本页正文的「常见问题」一节（`<h2 id="faq">`）取问答，每个 h3 是一问，其后的段落与列表转成纯文本作回答，不在 front matter 里另抄一份。Google 自 2023 年起只给少数权威网站展示 FAQ 富媒体结果，这份数据不为改变 Google 的展示，而是让其他搜索引擎与 AI 检索系统直接读到成对的问答；问答取自页面本身，没有额外的维护成本。
- **`llms.txt` 与 `llms-full.txt`**（写法与维护见 [content.md](content.md) 第九节）：
  - `llms.txt`：根目录一份手写的 `static/llms.txt`，按 llmstxt.org 的约定用英文写：开头列全「纯纯写作、純純寫作、Pure Writer、純純執筆」四个名字的概述，分节列出主要页面（注明各有哪些语言），次要的放 `## Optional`；
  - `llms-full.txt`：主要页面的全文合成的一个 Markdown 文件，以英文版为主体，附只有简体中文的几页的原文；构建时由 `layouts/index.llmsfull.txt` 从页面生成（英文首页的一种自定义输出格式，发布在根目录），开头的概述取自 `llms.txt`，不另外手写，免得与页面脱节。隐私政策只给链接；
  - 两者都是 `text/plain; charset=utf-8`，不参与语言协商，页面的 `<head>` 里不加指向它们的链接（llms.txt 没有约定 `<link>` 的写法）；
  - 不另外输出每页的 Markdown 版：Google 已说明搜索与生成式功能都不使用 llms.txt 与 Markdown 版，新站的 HTML 本身也已经干净。做这两个文件是为了其他 AI 助手与检索系统，代价只是一个手写文件与几个模板。
- **关键词**：每个可收录的页面写一行 `<meta name="keywords">`，只列这四个名字，本语言的写法在前。Google 与 Bing 已明确不看这个标签，百度没有明确的现行说法，个别搜索引擎仍会参考；名字能被搜到，主要靠上面的 WebSite 别名与各语言页面的标题。
- **iOS 智能横幅**：首页、各语言的 iOS 版介绍页、iOS 支持页与 iOS 隐私政策保留 iOS 智能横幅的 meta。
- **`/.well-known/security.txt`**：写明联系邮箱，Expires 在构建时自动生成为一年内的日期，不需要人记着更新。
- **`/baidu_verify_codeva-PxSFfSALDb.html`**：百度搜索资源平台的站点验证文件（`static/` 下，文件名与内容由百度给定），见第九节 E。
- **`/indexnow.txt`**：IndexNow 的密钥文件（`static/indexnow.txt`），正式站部署成功后推送有变化的页面时用到，见第九节 E。
- **不加任何统计脚本**。需要了解访问情况时，用 `ops/` 下的日志报告脚本（5.5）在服务器上做聚合。

更深入的 SEO 与 AI 可发现性工作放在第 E 步。

## 五、服务器

### 5.1 系统与更换方式：原地更换系统盘为 Ubuntu 26.04 LTS

- **为什么是 26.04**：
  - 免费标准支持到 2031-05，比 24.04 多两年；
  - OpenSSH 10.2 内建按来源惩罚（PerSourcePenalties）与后量子混合密钥交换；
  - 26.04.1 已于 2026-08 发布，「等第一个点版本」的观望期已经过去；
  - 阿里云公共镜像 2026-05 首发，至今仍在更新。
- **为什么原地更换系统盘**：实例和公网 IP 都不变，ICP 备案与公安联网备案不受影响，也不产生额外费用。
- **为什么不就地升级系统**：从 20.04 到 26.04 要连跳三个 LTS，1 GiB 内存、没有 swap、还装着第三方源和厂商代理，风险高；而且会留下五年的历史残留，违背「配置全部入库、可以重复执行」的目标。
- **为什么不新建实例**：要核实备案服务号对新实例的要求，还要承担并行期间的双份费用。为了省下一次短暂停机，不值得。
- **不做快照**。阿里云账号没有开通快照服务。换系统前，服务器上独有的少量数据会先拉回本机（5.5），服务器上于是没有不可再生的东西。新系统万一起不来，回滚路径就是再更换一次系统盘、重跑初始化。
- **先换服务器，后换网站**（第九节 A、C 两步）：
  1. 新系统先用 Caddy 继续提供旧站，同时修好 500 循环、`.git` 外泄和日文授权页。这一步只停机一次。
  2. 新站在同一台服务器上用 `writer2.drakeet.com` 预发（这条解析早已指向这台服务器），在真实的服务器、证书和国内网络里跑通全部检查。
  3. 最后切换网站只需改一处配置并重载，不停机，出问题可以立即切回旧站。

  好处有三：旧系统更早下线；新站上线前就在真实环境里验证过；正式切换没有停机。

### 5.2 Web 服务器：Caddy 2

单站点静态服务加上自动证书，正是 Caddy 的本职工作：

- 证书（Let's Encrypt 为主、ZeroSSL 兜底，支持 ARI 续期）、HTTP 到 HTTPS 的跳转、HTTP/2 与 HTTP/3 都是默认行为，不再需要 certbot 和定时任务；
- 「`/x` 对应 `x.html`、找不到返回 404」几行就能表达，旧站的 500 循环不会再出现。

**几项关键事实**：

- Let's Encrypt 的证书有效期 2027-02 起缩短为 64 天、2028-02 起缩短为 45 天，Caddy 的自动续期正好覆盖这个变化。
- Ubuntu 自带的 caddy 停在 2.6.2，太旧，所以用 Caddy 官方的 APT 源。2026-11-07 从这台服务器实测，官方源、Let's Encrypt、ZeroSSL 都能正常连通。
- 全局配置写明 ACME 联系邮箱：不写的话 Caddy 没有 ZeroSSL 兜底。默认用站上公开的反馈邮箱 writer@drakeet.com。

**受控升级**：Caddy 的补丁版本也可能带破坏性变更，例如 2026-11-04 的 v2.11.8 就改动了 `try_files` 与 `handle_errors` 的行为，所以不交给 unattended-upgrades 盲目升级。做法是：

1. `apt-mark hold caddy`。
2. 每周由服务器上的 `writer-caddy-upgrade`（systemd 定时器）检查新版本：
   1. 先用新版本的二进制校验现行配置；
   2. 通过后再安装、重载，对本机跑一遍关键地址的检查；
   3. 任何一步失败，就装回原版本并记日志。

这样既能及时拿到安全修复，又不会被行为变化打断服务。外加一个 systemd 片段 `Restart=on-failure`，Caddy 万一崩溃或被内存不足杀掉能自动拉起。

**备选方案**：Ubuntu 26.04 自带的 nginx 1.28。它的安全更新只回移补丁、不改行为，但要另配 certbot（universe 仓库里的版本没有 ARI），HTTP/3 在上游仍标为实验性；Drakeet 的其他服务器也用 nginx。两者都可行，选 Caddy 是为了少一个组件，以及更现代的默认值。

### 5.3 目录、账户与权限

```
/srv/writer.drakeet.com/releases/<UTC 时间>-<提交>/public/   站点产物（网站根目录）
/srv/writer.drakeet.com/releases/<UTC 时间>-<提交>/caddy/    这一版的站点规则 site.caddy
/srv/writer.drakeet.com/current → releases/…                当前版本，切换用 mv -T 原子完成
/srv/writer.drakeet.com/staging/…                           预发站的 releases 与 current，结构相同
/srv/writer.drakeet.com/jars/                                JAR 镜像，站点部署不会碰它
/etc/caddy/Caddyfile                                         全局配置（来自仓库 ops/caddy/），root 所有
```

**站点规则随版本发布**：

- `/etc/caddy/Caddyfile` 只放全局选项：ACME 邮箱、日志、管理接口、各主机名，以及「导入 `current/caddy/site.caddy`」。
- 站点规则（映射、协商、响应头、缓存头）与站点内容同属一个版本：一起部署，一起回滚。日常修改跳转规则不需要 root。
- 部署脚本切换 `current` 后，以 drakeet 身份让 Caddy 重载。Caddy 加载新配置失败时会保留旧配置并报错，部署脚本据此把 `current` 切回上一份。
- **切换与重载之间的空窗**：从切换 `current` 到 Caddy 重载完成，有不到一秒是旧规则配新内容；Caddy 拒绝新规则、切回原版本时同理。接受它，理由是：
  - 机器依赖的地址（AASA、`desktop2.json`、`/images/`、JAR）在新旧两版规则下行为相同；
  - 只有部署改了规则时才有影响；
  - 按现在的访问量，这段时间里平均不到一次请求；
  - 彻底消除要把 writer-release 与全局 Caddyfile 改成按版本导入，不值得。
- Caddy 的管理接口只监听一个 unix socket，权限限定为 caddy 组；drakeet 加入这个组，其他本机用户无权改配置。

**账户**：

- **`drakeet`**：唯一的登录账户，只能用密钥登录。它拥有 `/srv/writer.drakeet.com`；在 `adm` 组里，可以直接读日志；在 `sudo` 组里，收回免密 sudo 之后凭口令取得 root；在 `caddy` 组里，可以经管理接口重载 Caddy。部署站点、触发 JAR 同步都用它。
- **重建期间**：drakeet 有免密 sudo，文件名沿用 `/etc/sudoers.d/90-drakeet-nopasswd`，这样收尾的命令不用改。
- **收尾后的终态**：
  1. Drakeet 在自己的终端里给 drakeet 设口令（`ssh -t drakeet@writer.drakeet.com sudo passwd drakeet`，口令由他本人输入）；
  2. 再收回免密 sudo。

  此后 sudo 需要输入这个口令，与 api.drakeet.com 的做法一致；阿里云控制台的远程终端也用 drakeet 和这个口令登录。root 保持锁定，不能经 SSH 登录。
- **不另设部署账户**：部署用的密钥和管理用的密钥都在同一台 Mac 上，再加一个账户只增加复杂度，并不缩小暴露面。将来如果改由 CI 部署，再加一把用 `rrsync` 限定目录的专用密钥。

**初始化的顺序**（防止把自己锁在外面）：

1. 以更换系统时注入密钥的 root 运行 `ops/provision.sh`，并保持这个会话不断。
2. 先建 drakeet 与它的 authorized_keys，另开一个连接确认 `ssh -o BatchMode=yes drakeet@writer.drakeet.com true` 成功。
3. 然后才写 SSH 配置片段并重载；ufw 先放行 22 再启用。
4. 最后从外部确认 root 登录被拒绝，并且 `ssh -v` 显示只剩公钥认证。只看 `sshd -T` 不够：它读的是配置文件，证明不了正在运行的 sshd 已经重载。

### 5.4 加固清单

- **SSH**：配置片段 `/etc/ssh/sshd_config.d/00-writer.conf`，文件名要排在云镜像自带的 `50-cloud-init.conf` 前面，因为 sshd 对同一项取第一次读到的值。
  - 内容：只接受公钥、禁止 root 登录、`AllowUsers drakeet`、关闭 X11 与代理转发；
  - 算法用 OpenSSH 10.2 的默认值；
  - 不装 fail2ban：只用密钥加上内建的 PerSourcePenalties，已经覆盖了它在 SSH 上的作用。
- **防火墙**：
  - ufw 默认拒绝入站，只放行 TCP 22、80、443 与 UDP 443；
  - 安全组保持同一份白名单，两处的规则写在 `docs/operations.md` 的同一张表里；
  - 80 端口不限来源，ACME 验证需要；
  - 个人代理的 TCP 8621：旧规则 2026-11-07 随换系统删除，2026-11-08 重新部署代理时加回（operations.md 第 3 节、第 10 节）。
- **自动安全更新**：
  - unattended-upgrades 安装 security 来源的更新，需要重启时在凌晨 04:30（上海时间）自动重启。旧机 695 天不重启、内核补丁从未生效，是这次最大的教训；
  - Caddy 不在其中，走 5.2 的受控升级；
  - 装好后、以及过几天，各核对一次它确实在运行。
- **出口整形与拥塞控制**：
  - 带宽只有 2 Mbps，超出的包会在阿里云那一侧被直接丢掉，小请求（例如一个网页）会因为丢包反复重传；
  - 在服务器出口用 CAKE 整形到略低于 2 Mbps：排队发生在机器内，按连接公平轮转，有人下载 JAR 时网页依然流畅；
  - 同时启用 BBR 拥塞控制；
  - 切换后在真实流量下实测，确有改善才保留。
- **HTTP/3 的 UDP 缓冲区**：按 quic-go 的建议调大 `net.core.rmem_max` 与 `wmem_max`。
- **时间同步**：chrony，使用阿里云内网的多个 NTP 源（镜像默认配置），装好后核对实际时钟源。
- **日志**：
  - Caddy 访问日志用 JSON 格式，记录主机名（旧日志不记主机名，几个站点的访问混在一起）；
  - 保留 183 天后删除（`roll_keep_for 4392h`，`roll_keep` 设足够大），文件权限 0640；
  - `/var/log/caddy` 属 `caddy:adm`、权限 2750，drakeet 无需 sudo 就能读；
  - 《网络安全法》要求网络日志留存不少于六个月；日志含访客 IP，留够期限就删；
  - journald 设上限 1 GB。
- **swap**：2 GiB 的 swapfile。1 GiB 内存正好是 Ubuntu 云镜像的最低要求，`apt` 升级时容易内存不足。
- **阿里云代理**：保留镜像自带的云助手（控制台的救援通道）与云监控；更换系统时「免费安全加固」按默认勾选。实测它的两个进程（AliYunDun、AliYunDunMonitor）合计约 64 MB，加固后可用内存约 520～580 MiB，暂不需要卸载，内存吃紧时再评估。
- **精简**：卸载用不到的组件，例如镜像如果自带 snapd 又用不上。

### 5.5 监控、检查与备份

**URL 合同检查**：`ops/contract.tsv` 是第三节与 4.5、4.6、4.9 的逐条期望，唯一正本；由 `ops/contract.py` 执行，只用 Python 标准库。两者随站点版本发布，在版本目录的 `checks/` 下。

- **表的格式**（完整说明在表头注释里）：每行一个用例，7 列，用制表符分隔，依次是路径、请求头、状态码、Location、Content-Type、响应头、内容；以 `#` 开头的行是注释，按主题分节，写明合同的口径。不跟随跳转，每列分别核对。
  - 路径按线路上的原样写，非 ASCII 字符与空格写成百分号编码。几种特殊写法：`{version}` 换成站点 `/desktop2.json` 里的版本号；`/css/* from /zh-hans/` 取该页面里第一个以 `/css/` 开头的地址（带内容指纹，每次构建都会变）；`http://{host}/…` 走 80 端口。
  - 请求头写成「名字: 值」，多个用「 | 」分隔，`-` 表示不带；「名字:」后面不写值，就发一个空的请求头；`:method: HEAD` 一类写法改用别的请求方法。
  - 响应头有四种写法：「名字: 片段」表示含有，「名字 == 值」表示完全相等，「名字 =~ 正则」表示整个值符合，「!名字」表示不应有。
  - 内容列写必须出现的文字，以 `!` 开头的表示不应出现；gzip 压缩的响应先解压再核对。
- **contract.py**：逐条报告不通过的是哪一行、期望什么、实际什么。有任何一行不通过以 1 退出；连续 5 行请求失败（连接错误、超时）就停止检查、报告还有多少行没跑，同样以 1 退出；表本身写错、或一行用例都没有，以 2 退出。被检查的是我们自己的 Caddy，不另设整轮的总期限。
- **三个运行时机**：
  1. 改站点规则或合同时，`scripts/test-caddy.sh` 在本机按服务器的目录结构搭测试台，用与服务器同版本的 Caddy 跑整张表（本机只有 HTTP，`http://` 的两行跳过）；drakeet.com 的跳转规则与它单独的合同也在这里一起跑（5.7）；
  2. 每次部署（正式站与预发站）切换之后，`scripts/deploy.sh` 在服务器上运行这一版附带的表：`--site <主机名>` 连本机 127.0.0.1 的 443 端口，按主机名带 SNI、校验证书，不经 2 Mbps 的公网；不通过就自动回滚；
  3. Caddy 受控升级的自检（5.2）改为运行当前版本附带的表，这样补丁版本改动 `try_files`、改写或错误处理时也能被发现。这一项在第 C 步接入，在那之前它只查 AASA、首页与一个不存在的路径（应为 404）。
- **合同不核对文件字节**：`writer-jars-sync` 按 sha256 校验之后才把 JAR 放进镜像（5.6），合同只用 HEAD 请求核对 `desktop2.json` 里当前版本的三个 JAR 存在、缓存头正确，不必每次部署都在 1 GiB 内存的服务器上把约 120 MB 读一遍。固定图片的原字节在构建时按入库的清单 `ops/images.sha256` 核对（第六节）。
- 合同还包括：不带语言头和带 `zh-CN` 访问 `/`，都应 302 到 `/zh-hans/`，并且页面含备案号、指向 `https://beian.miit.gov.cn/` 的链接与公安备案号。

**外部监控（必做）**：Caddy 的自动拉起与受控升级都依赖「出了问题有人知道」，所以这一项不是可选的。

- **做法**：GitHub Actions 的定时任务（`.github/workflows/monitor.yml`），每 15 分钟检查首页、AASA、`/desktop2.json`、该版本的三个镜像 JAR（只发 HEAD）、http 跳转与证书剩余天数；每个请求带重试，整轮不通过时隔两分钟重查，两轮都不通过才让运行失败，由 GitHub 发邮件给 Drakeet。2026-11-07 上线并实测通过。
- **为什么不用阿里云**：原计划的阿里云站点监控已并入「网络分析与监控」，2026-11 起按拨测次数计费（三个运营商探测点每 15 分钟一次约 9 元／月）。Drakeet 选了不花钱的 GitHub Actions；代价是检查点在境外、调度常有延迟，所以它只用来发现「挂了」。
- **第 C 步**：首页改为按语言跳转后，更新 `monitor.yml` 里的期望；合同表就绪后，可以改为执行合同表里标记为「监控」的几行。

**日志报告**：`ops/` 下的日志报告脚本，按需汇总 404 最多的地址、旧地址的跳转命中、各语言的访问量，及时发现断链。

**备份**：不需要常规备份。站点与配置都在仓库里，证书可以重签，JAR 可以从 R2 重新拉取。

**换系统前的一次性工作**：

- 拉回服务器上独有的东西，存进本机不入库的 `evidence/`：drakeet.com 的页面、nginx 配置、个人代理的配置，以及旧机上全部访问日志（为满足六个月留存，到 2027-05 删除）；
- 停机前最后一刻再增量拉一次访问日志。

### 5.6 JAR 国内镜像：由服务器从 R2 拉取

**用途**：国内有的用户连不上 Cloudflare，所以 R2（kuromi.drakeet.cn）上的桌面版 JAR 要在这台国内服务器上也放一份。rebase-server 对报告连不上 GitHub 的客户端，约一半把下载地址改写到 `https://writer.drakeet.com/ocat/jars/`。桌面版 CI 也用这个地址兜底。

**旧做法的问题**：

- 发版时由 `buildAllJars.sh` 从 Drakeet 在日本的电脑经 SFTP 上传三个包，约 127 MB；晚高峰每个包要传约 40 分钟；
- 上传后从不清理，已经积累了 6.5 GB。

**新做法**：

1. `buildAllJars.sh` 照旧先把 JAR 传到 R2。
2. 之后改为执行 `ssh drakeet@writer.drakeet.com writer-jars-sync <版本> <文件名>=<sha256>…`。
3. 服务器上的 `writer-jars-sync` 依次完成：
   1. **校验参数**：版本号是点分数字，文件名只能是三个平台的固定格式，sha256 是 64 位十六进制，下载地址用固定的 R2 基址拼接；
   2. **下载**：从 R2 下载到网站不对外提供的临时目录，带重试、超时与断点续传；地址加上 `?sha256=<值>`，绕过 Cloudflare 边缘可能缓存的旧文件；
   3. **核对与放置**：逐个核对 sha256，全部通过后设为 0644，再原子地放进 `jars/`；已存在、哈希一致的文件直接跳过，可以放心重跑；
   4. **清理**：按版本号保留最近 7 个版本，永不删除本次同步的版本。
4. `buildAllJars.sh` 在提交 JarVersions 之前，从本机对镜像地址发一次 HEAD 请求，核对状态码与大小，与它对 R2 的现有核对对称。
5. 加一个只做同步的续跑入口：先核对本地 JAR 与 R2 一致，再调用 `writer-jars-sync`，最后提交 JarVersions。同步失败时重跑它即可，不必重新构建。

**为什么保留 7 个版本，而不是只留最新版**：镜像该有哪个版本，取决于已部署的 rebase-server 下发哪个版本，而它常常落后好几版（日志里最长滞后 4 天、跨 3 个版本）。只留最新版或最新两版，会在服务端部署之前删掉它仍在下发的文件，让被分流到镜像的国内用户自动更新失败。7 个版本约 0.9 GB，与 R2 的保留量相当；更早的历史版本照旧不留，与「旧版没有意义」的裁决一致。

**首次同步**：取 R2 上现有的全部版本（4.9.1、5.0.0、5.0.1、5.1.0），sha256 取自 rebase-server 里 JarVersions.kt 的历史提交。

**正式采用前**：在上海时间 21～22 点实测一次从 R2 拉取三个包的速度。2026-11-07 上午首次同步时实测：每个版本三个包（约 127 MB）约 2 分钟，晚高峰仍待实测。

**以后可以考虑**（不在本轮）：桌面端在 R2 下载失败时改用镜像重试一次，或由 rebase-server 同时给出两个地址。这样「能连 GitHub、连不上 Cloudflare」的用户也能受益，镜像的负担也更小。

### 5.7 其他托管

- **drakeet.com 与 www.drakeet.com：301 到本站的根地址 https://writer.drakeet.com/；旧介绍页链接着的 `/privacy`、`/terms` 仍到 ocat.app。**
  - **现状**（2026-11-08 核对）：DNS 上，drakeet.com 是指向 writer.drakeet.com 的 CNAME，www.drakeet.com 是指向本机的 A 记录，两者都没有 CAA 记录（阿里云权威 DNS 对根域名的 CAA 查询回 NODATA）。换系统后由全局配置里这两个主机名的站点块原样提供旧服务器备份下来的 OCAT 介绍页（`/srv/legacy/drakeet.com`）。这个页面链接着 `/privacy` 与 `/terms`，服务器上从来没有这两个文件，一直是 404。新服务器上线以来的访问日志里，真实的请求几乎只有首页与这两个地址，其余都是扫描器的探测。
  - **为什么跳转**：这里的旧页停在 2025 年，说法与 OCAT 自己的官网 ocat.app 不一致（例如介绍页说「不收集任何隐私信息」，DeepOCAT 的隐私政策页又列出了收集的数据，10.1 第 6 条），留着只会误导，所以不再提供页面。2026-11-08 起先是一律 301 到 ocat.app；2026-11-12 改为到本站（Drakeet 定）：搜索引擎按子域名的根地址取站点名，取不到时退回主域名首页的，主域名跳到 ocat.app 的几天里，Google 把 writer.drakeet.com 各页的站点名显示成了「OCAT App」（Search Console 里本站的根地址当时还是「Google 不知道的网址」）。主域名的首页落到本站之后，退回的名字也是纯纯写作。
  - **规则**：`/privacy`、`/terms`（区分大小写，允许一个尾斜杠）是旧介绍页链接着的 OCAT 隐私政策与使用条款，仍 301 到 ocat.app 上对应的页面：跳到本站会落到纯纯写作 Android 版的隐私政策（本站的旧地址 `/privacy`），文不对题。其余一律 301 到本站的根地址，由它按访客语言协商到各语言的首页（4.5）；查询串原样带上，缓存一天，与本站旧地址的 301 一致。不保留路径：那样会把这里从来没有过的地址变成本站的地址。跳转目标只由固定写法拼成，不带请求里的原始路径，所以拼不出跳到别处的地址。本站的 DeepOCAT 旧页（第三节）不受影响，照旧 301 到 ocat.app 的首页、`/privacy` 与 `/terms`，`static/ocat/` 已删除。
  - **放在哪里**：规则写在 `ops/caddy/drakeet.com.caddy`，由 `ops/provision.sh web` 装到 `/etc/caddy/`，全局配置在这两个主机名的站点块里导入它。它与站点内容无关，不随站点版本发布、回滚，所以合同单独成表 `ops/contract-drakeet.com.tsv`，不放进每次部署都跑的 `ops/contract.tsv`；`scripts/test-caddy.sh` 在测试台导入同一份规则跑这张表。装到服务器与对线上核对的步骤见 operations.md 第 6 节。
  - **证书**：照旧由 Caddy 自动签发，跳转之前要先完成 TLS 握手。drakeet.com 没有 CAA 记录，不限制签发的 CA。
  - **上线**：2026-11-08 装到服务器并平滑重载，两个主机名的合同对线上各 17 行全过。2026-11-12 改为到本站的规则同样装到服务器并平滑重载（0ddace5），合同对线上各 17 行全过。服务器上原来的 `/srv/legacy/drakeet.com` 与 `/root/writer-provision/drakeet.com` 随后删除（`provision.sh` 也不再复制它们）；原页面在本机 `evidence/website-rebuild-2026-11/server-backup/drakeet.com/` 留有备份。
  - **DNS**：根域名原来是指向 writer.drakeet.com 的 CNAME，又同时有 MX 等记录，不符合 DNS 规范（一个名字有 CNAME 就不能再有别的记录）。2026-11-08 改为指向本机公网地址的 A 记录，与 www 一致；MX（Google Workspace）与 TXT（Search Console 等的域名验证）不变，权威 DNS 上核对过。writer2.drakeet.com 是现役的预发站（`scripts/deploy.sh --staging`），解析保留。
- **个人代理服务**：不放进主线，`provision.sh` 不安装它。2026-11-08 按需重新部署（Ubuntu 官方源的 shadowsocks-libev，只开 TCP），做法与理由见 operations.md 第 10 节。

## 六、构建、部署与回滚

**工具链**：Hugo 标准版，版本固定在开工时的最新稳定版（2026-11 为 v0.169.0）。`scripts/hugo` 首次运行时从 GitHub Releases 下载指定版本、核对 SHA-256，放进本机缓存，之后每次构建都用这个版本。不需要 Node 或 npm。

**命令**：

| 命令 | 作用 |
|---|---|
| `scripts/dev.sh` | 本机实时预览 |
| `scripts/build.sh` | 从当前已提交的 HEAD 构建（`git archive` 到临时目录；`--worktree` 则构建脚本所在的这份目录），再跑不需要服务器的检查：构建警告视为错误、期望产物清单、站内链接全部可达、本地化与市场差异检查、固定图片按 `ops/images.sha256` 核对原字节、Apple 关联域名文件是合法的 JSON 且含本 App、本机运行的 bash 脚本没有 `$名字` 紧跟非 ASCII 字符（macOS 的 bash 3.2 在 UTF-8 环境下会报 unbound variable） |
| `scripts/deploy.sh` | 取一次完整的提交号并做分支判断 → 取得部署锁 → 把这个提交 `git archive` 解到临时目录，用其中的 `scripts/build.sh --worktree` 构建并检查，站点规则与 URL 合同也取自这同一份 → `rsync --link-dest` 上传到新的 release 目录 → 记下服务器上切换前的版本，由 writer-release 用 `mv -T` 切换 `current` 并重载 Caddy（Caddy 拒绝新规则时切回原版本），只保留最近 5 份 → 在服务器上跑这一版的 URL 合同，正式站另核对线上 `desktop2.json` 的版本，失败就自动切回切换前的版本并报错 → 正式站部署成功后把内容有变化的页面推送给 IndexNow（第九节 E），推送失败不影响部署结果。上传按内容比较（`--checksum`）、不保留修改时间：构建产物的时间每次都会变，按时间比较就得整站重传；这样内容未变的文件与上一版硬链接，实际传输的只有改动，ETag 也保持不变。只用 macOS 自带的 openrsync 也支持的选项 |
| `scripts/deploy.sh --staging` | 同上，部署到预发站 writer2.drakeet.com，任何分支都可以 |
| `scripts/deploy.sh --rollback` | 把 `current` 切回上一份，并重载 Caddy；同样先取得部署锁 |
| `scripts/deploy.sh --indexnow-only` | 不部署，把正式站当前版本 sitemap 里的全部地址推送给 IndexNow，用于补推与首次验证（第九节 E）；同样先取得部署锁 |
| `scripts/test-caddy.sh` | 改站点规则或合同之后在本机自查：按服务器的目录结构搭测试台，用与服务器同版本的 Caddy 跑整张 URL 合同；`--public` 用已经构建好的产物，`--keep` 留下测试台便于排查 |
| `ops/provision.sh` | 服务器初始化，可重复执行，分两段：第一段只做恢复服务所需的事，第二段做其余加固；需要 root |

**几条规则**：

- **只部署已提交的内容**：deploy.sh 开头取一次提交号，产物、构建工具（Hugo 的版本、检查脚本与 `ops/` 下的检查配置）、站点规则与合同都取自这一个提交，部署内容与提交历史严格一致；工作区里的草稿、构建期间别人新做的提交都不影响部署，也不会挡住桌面发版。
- **同一时间只有一次部署**：部署都从这台 Mac 发起（桌面版 release.sh 与手动部署），deploy.sh 在 git 公共目录里取一把锁，覆盖从构建到回滚（含 `--rollback`）的全过程，部署后的 IndexNow 推送与 `--indexnow-only` 也在锁内。两次部署交错时，失败的那次会把后完成的那次一起回滚掉，加锁就去掉了这个前提。锁已存在时一律拒绝，不自动接管：持有它的进程还在，说明另一次部署正在进行；已不在，是上次部署被强杀或机器死机留下的，deploy.sh 打印锁里的记录与移除命令，确认没有部署在进行后手动移除。正常退出、出错与 INT、TERM、HUP 都会释放锁，遗留锁很少出现，手动处理的代价很小。
- **切换失败与中断**：deploy.sh 在切换之前记下服务器上的当前版本，自动回滚用 `writer-release activate <环境> <那个版本>` 明确切回它，不依赖服务器上记录的 previous（writer-release 在切换、重载成功之后才写 previous，那之前出错时它还是更早的一版）。writer-release 报告失败时，deploy.sh 先查服务器上 `current` 实际指向的版本：已是这次的版本就照常检查、不通过再切回，否则如实报告是哪个版本。切换开始之后被中断，打印查看状态与切回原版本的命令（current 是哪个版本都可以直接运行）后以非零退出。
- **生产部署的分支要求**：只接受 `master`。唯一的例外是第 C 步的首次部署：用一个只为这一次放行 `rebuild` 的显式参数，验收通过后主目录再快进到同一个提交，然后删掉这个参数。
- **桌面发版路径上不做与发版无关的拦截**：与时间有关的检查（例如证书或文件将要到期）在 deploy.sh 里只告警。

**为什么在本机构建，而不是 CI**：

- release.sh 本来就在这台 Mac 上运行；
- 部署凭据不用交给第三方；
- 工具版本固定，构建可以复现。

以后如果需要，可以加只做构建检查、不做部署的 CI。

## 七、与各端流程的衔接

| 相关方 | 现在 | 第 A 步之后 | 第 C 步之后 |
|---|---|---|---|
| 桌面版 release.sh 的 site 步骤 | 写仓库根目录的 `desktop2.json`，提交并推送 | 不变；预检新增一项：官网 `master` 上若有不是本脚本留下的未推送提交，就停下提示，免得把别人的改动一并推上线 | 不变 |
| release.sh 的 deploy 步骤 | ssh 到服务器 `git pull`，再 curl 校验 | 改为调用站点仓库的 `scripts/deploy.sh`，再做同样的 curl 校验 | 不变（`master` 上的 deploy.sh 换成新站的版本，接口相同） |
| `buildAllJars.sh` | SFTP 上传到站点目录 | R2 上传不变；改为 ssh 触发服务器从 R2 拉取，加上镜像核对与续跑入口（5.6） | 不变 |
| 桌面版 CI 的兜底下载 | `writer.drakeet.com/ocat/jars` | 不变 | 不变 |
| rebase-server | JarVersions、Drives、RawJsonResource 里的地址 | 不需要改，也不需要部署 | 可选：授权完成页与「检查更新」直接指向新地址，少一跳 |
| 站点主目录 `master` | 旧站 | 新增旧站用的 `scripts/deploy.sh`（只上传网站文件，排除仓库文件） | 快进到新站 |
| iOS 仓库文档 | `docs/privacy.md` 写着 `ios/privacy.html` 和「Drakeet 不定期拉取」 | 改为新的部署命令；顺带更正已过时的说法 | 改为新的源文件位置（`content/ios-privacy/`） |
| 本机记忆「官网部署方式」 | 旧的 git pull 流程 | 重写（先请 Drakeet 确认内容），去掉「只提交不推送」的说法 | 再次更新 |
| 本机 `known_hosts` | 旧主机密钥 | 换系统后经云助手核对新指纹再写入 | — |
| GitHub 镜像仓库 | 开着 GitHub Pages（legacy Jekyll） | 关闭 | — |
| Google OAuth 同意屏幕 | 登记 `/home_en` 与 `/privacy_en` | — | 不改：两个旧地址都 301 到新页面，同意屏幕照常可用 |

## 八、过渡期安排

- **工作目录**：已按 Drakeet 的同意调整：主目录在 `master`（旧站，桌面发版、iOS 隐私政策修改、手工部署照常进行），新站在 `writer.drakeet.com-rebuild` 工作树里开发。
- **定期把 `master` 合进 `rebuild`**：至少在每次 iOS 隐私政策改动之后、以及第 C 步开始时各做一次。
  - `desktop2.json` 两边路径相同，合并时自然更新；
  - `rebuild` 删掉、`master` 上又改过的旧页面，git 会报 modify/delete 冲突，正好逐个提醒移植（例如隐私政策的改动移进 `content/ios-privacy/`）；
  - `git log rebuild..master` 为空，就证明没有遗漏。

  第 C 步时 `master` 只需 `git merge --ff-only rebuild`，推上去的就是部署、验收过的那个提交。
- **第 C 步之前，不得把 `rebuild` 合进或推到 `master`**：release.sh 会把 `master` 上的提交一并推送并部署。第 A 步新增的预检会拦下意外。
- **要延后上线的官网改动放分支，不放 `master`**：2026-10-30 的 iOS 隐私政策提交就是在 11-05 随桌面 5.0.0 一并上线的，比原计划早。

## 九、实施步骤与验收

### A. 服务器先行：换系统，新系统上继续提供旧站

1. **准备**（不停机）：
   - 在 `rebuild` 里写好 `ops/`：两段式初始化、全局 Caddyfile、旧站规则（仿旧站行为并修好 500、`.git`、`_ja` 等问题）、预发站的导入、服务器端脚本、URL 合同表；
   - 在 `master` 里加旧站用的 `scripts/deploy.sh`；
   - 在桌面仓库的分支上改好 release.sh 与 `buildAllJars.sh`；
   - 用本机的 Caddy 把旧站规则对旧站文件跑一遍合同检查；
   - 在阿里云导入 `~/.ssh/id_rsa.pub` 为密钥对，并核对指纹；
   - 关闭 GitHub Pages。
2. **演练（未做：Drakeet 决定不演练、直接换，改为窗口开头只读核对镜像差异）**：开一台同地域、同规格、同镜像的按量付费临时实例，按正式顺序完整跑一遍初始化、旧站部署与 JAR 同步，证书用 Let's Encrypt 测试环境，记下每一步的耗时，然后释放。费用估计几元以内。这台实例能验证阿里云镜像自身的差异：初始用户、cloud-init 写的 SSH 配置、apt 源、预装代理的内存占用，本机虚拟机验证不到这些。若不做，就在正式窗口里先花几分钟只读核对这些差异，再运行初始化。
3. **备份**：拉回服务器上独有的数据（5.5）。
4. **窗口**（避开上海时间 20～23 点；对外按 60 分钟沟通，目标 30 分钟）：
   1. 确认没有桌面发版在跑，请 Drakeet 在窗口结束前不发桌面版；
   2. 最后一次增量拉回访问日志；
   3. 停止实例 → 更换系统盘为 Ubuntu 26.04（选导入的 RSA 密钥对）→ 启动；
   4. 经云助手取新主机密钥的指纹，本机 `ssh-keygen -R` 删掉旧条目，首次连接时比对指纹再接受；
   5. 初始化第一段（Caddy、账户、SSH 与 ufw）；
   6. 部署旧站，同步 JAR；
   7. 线上合同检查（旧站部分）通过，停机结束。
5. **服务恢复后**：
   - 初始化第二段：系统更新、swap、journald、自动更新、出口整形、受控升级的定时器；如有必要再重启一次，中断约一分钟；
   - 合并桌面仓库的改动，跑 `./release.sh --from site --dry-run` 与 `./buildAllJars.sh --sync-only`（完整的 `--dry-run` 会被 tag 预检挡下，也走不到改动的两条路径；`--sync-only` 对已发布的版本没有副作用）；把 `master` 上的 `scripts/deploy.sh` 推送；
   - 更新 iOS 文档与记忆；配置阿里云站点监控；解除冻结。
6. **验收**：
   - 旧站的合同检查全部通过；
   - 用当前 JarVersions 的版本，从镜像下载三个 JAR，哈希一致；
   - `writer-jars-sync` 对当前版本幂等地重跑一次；
   - 一次 `--from site` 演示，以及一次回滚演练；
   - GitHub Pages 已关闭。

**执行记录（2026-11-07）**：

- **时间线**（上海时间）：旧 nginx 最后一条访问 10:06；新系统 10:14 首次启动；10:20 起显示维护页；10:25 旧站恢复。实际中断约 17 分钟。之后为检验开机自启重启过一次，中断 35 秒。
- **镜像的实际差异**：没有建 ecs-user；root 只认注入的密钥；sshd 默认允许 root 登录、没有任何 `sshd_config.d` 片段；ufw 未启用；apt 源是阿里云内网镜像；时区已是上海；内存 889 MiB、没有 swap；预装的 ModemManager、udisks2、multipathd 用不上但占用不大，暂留。
- **窗口里发现并当场修正的问题**：
  - `provision.sh web` 以 root 运行 `caddy validate`，校验先把日志文件建成 root 所有，Caddy 随后起不来；改为以 caddy 身份校验，并修正已有文件的属主；
  - 旧站 deploy.sh 的 `--chmod=D755,F644` 不被 macOS 自带的 openrsync 接受；改为本地统一权限，并按内容比较上传，第二次部署 90 个文件全部与上一版硬链接；
  - 旧站 `master` 的 `.gitignore` 忽略 `*.sh`（旧部署把仓库直接放在网站根目录时，用来避免脚本被访问），为 `scripts/` 放行。
- **第二轮复审**（第十二节）的必改与应改项在执行 `ssh`、`harden` 两步之前并入脚本。
- **验收**：旧站全部关键地址与仓库逐字节一致；四个主机名的证书签发正常；12 个 JAR 的 sha256 与 JarVersions 的记录一致，`writer-jars-sync` 对当前版本幂等重跑（经 `--sync-only`）；`--from site --dry-run` 与一次回滚演练通过；GitHub Pages 已是关闭状态。

### B. 新站开发与预发

1. **骨架与工具链**：Hugo 固定版本、语言配置、基础模板与样式、检查脚本、期望产物清单。
2. **内容迁移**：所有页面、所有语言，以线上 HTML 为准迁成 Markdown 或 HTML 内容文件。sources/ 原稿与线上已有分叉的地方，以线上为准。此外还要完成：
   - 4.4 的旧锚点；
   - 下载页、授权完成页、404；
   - 4.10 的基础项。
3. **预发**：持续部署到 writer2.drakeet.com，对预发站跑完整的合同检查。

验收：

- 逐页文本比对报告：去掉标记后，旧页与新页的正文一致，差异只来自第一节第 5 条允许的修正；
- 期望产物清单与站内链接检查通过；
- 预发站的合同检查全部通过。

### C. 切换网站（不停机）

**操作前提**：开始首次切换前，确认没有桌面发版在进行；从首次切换（第 2 步）到 `master` 快进完成（第 4 步）之前，不发桌面版。`master` 上的旧部署脚本不参与部署锁，与首次切换交错时，一方失败后的自动回滚会把另一方的部署一起撤掉。`master` 快进之后用的就是新脚本，这条前提随之解除。

1. 最后一次把 `master` 合进 `rebuild`。
2. 从 `rebuild` 运行 `scripts/deploy.sh --first-cutover-from-rebuild`。全局 Caddyfile 早已导入 `current/caddy/site.caddy`（第 A 步起旧站的规则也随版本发布），所以首次切换就是一次带参数的部署：新站内容与新站规则一起成为 `current`，不用改全局配置。
3. deploy.sh 在切换之后对线上跑完整合同。失败就自动切回旧站的版本，内容与规则一起，立即生效。
4. 通过后，主目录 `git merge --ff-only rebuild` 并推送到 gitee 与 GitHub；更新 iOS 文档的源文件位置。
5. 切换后一并完成：
   - 删掉 deploy.sh 的 `--first-cutover-from-rebuild`；
   - 更新 `.github/workflows/monitor.yml` 的期望（首页改为按语言跳转，5.5）；
   - `writer-caddy-upgrade` 的自检改为运行当前版本附带的合同（服务器配置，在 `master` 的 `ops/` 里改）；
   - `docs/operations.md` 补上 URL 合同、`--staging`、`scripts/test-caddy.sh` 与部署锁。

验收：

- 合同检查全部通过；
- 一次 `--from site` 演示，确认桌面发版流程畅通；
- 一次 `--rollback` 后再部署回来，确认回滚可用。

**执行记录（2026-11-07）**：

- **切换前**：外部监控的首页检查改为跟随跳转，新旧两站都能通过，先推送到 `master`（5c5d219）。`master` 合进 `rebuild`（2a86b3a）：旧站首页的下载链接改动与删除冲突，保留删除，改动已移植到新站的简体首页（32602f2）。
- **切换**：18:41:58～18:43:47（上海时间）运行 `scripts/deploy.sh --first-cutover-from-rebuild`，整站上传加切换不到 2 分钟，不停机。服务器上的合同 500 行全部通过，线上 `desktop2.json` 的版本核对通过；从公网抽查关键地址正常，日文的网盘授权页在旧站一直是 500，现在是 200。
- **切换后**：`master` 快进到 2a86b3a，推送到 gitee 与 GitHub。收尾提交 a788982：
  - 删掉首次切换的参数；
  - 受控升级的自检改跑合同。只单独安装了这个脚本，没有重启 Caddy；单独跑自检，29 秒通过；
  - 运维手册与 AGENTS.md 按新站更新。
- **验收**：
  - 合同检查：切换时与回滚演练之后各通过一次，都是 500 行全部通过；
  - 回滚演练：18:51:08 回滚到旧站，18:51:34 回滚回新站，旧站在线约 26 秒；旧站上的受控升级自检退回三项检查，通过；
  - `--from site` 演示：release.sh 在 `master` 上不带参数调用 `scripts/deploy.sh`，与新脚本的接口一致，部署后核对的 `/desktop2.json` 地址也不变（对照代码确认）。它的 dry-run 不执行部署脚本，所以真正的检验在下一次桌面发版。

### D. 上线后一周

- 核对自动更新确实运行过、Caddy 受控升级的定时器正常、证书续期正常、日志按期滚动；
- 实测出口整形的效果，决定是否保留。

### E. SEO 与 AI 可发现性

- **站长平台**：Google Search Console 已添加站点并提交 sitemap（2026-11-08，网址前缀资源 `https://writer.drakeet.com/`）。必应站长平台（Bing Webmaster Tools）2026-11-12 改为要做（Drakeet 定），当天已从 Search Console 导入本站：它的索引同时供给 ChatGPT 搜索与 Copilot。导入时授权的是 Search Console 所在的 Google 账号（只读权限，必应用它定期复核验证状态与 sitemap），只导入了 `https://writer.drakeet.com/`，同一账号下的 drakeet.com 与 ocat.app 没有导入；sitemap 随之导入。百度搜索资源平台同一天也改为要做（Drakeet 定）：账号 drakeet，站点 `https://writer.drakeet.com`，站点领域选「工具服务及在线查询」与「信息技术」（有意不选「书籍文档」，与「文本编辑器、不提供阅读内容」的定位一致；验证成功后 30 天内只能改一次），用文件验证：验证文件 `static/baidu_verify_codeva-PxSFfSALDb.html` 发布在根目录，站点规则第 2 段把它列进 `@static` 原样提供，合同核对它的内容。百度会定期回来读这个文件，不能删。不用 HTML 标签验证：它读的是首页，而根地址会按语言 302。2026-11-12 验证通过（5e22554 部署之后）。验证当天提交不了任何地址：新站点的 sitemap 配额是 0（输入框禁用，页面提示填写主体备案号可以提高上限），「普通收录」的手动提交也回「您今日的链接提交量已达上限，请改天提交」（它与 API 推送共用配额）。当天在「站点属性」里填了主体备案号（闽ICP备2021006387号）、把站点类型由默认的「PC 站」改为「自适应」，配额当天仍是 0。同一页的「关联主体」还是未关联，页面写着「站点关联主体后即可提交资源」，配额一直不放开的话多半卡在这里；关联主体要做主体认证，由 Drakeet 决定做不做。改天再做：先看配额是否放开，放开后提交各语言自己的 sitemap（`https://writer.drakeet.com/zh-hans/sitemap.xml` 等）。百度不处理索引型 sitemap，提交了还会挡住之后的提交，所以不要提交根目录的 `/sitemap.xml`。也可以手动提交简体各页与繁体、英文的主要页面（每次最多 20 条；带跳转的地址要提交跳转后的，所以不提交根地址）。平台上几乎每一步操作（添加站点、手动提交、抓取诊断）都会弹滑块验证，得由 Drakeet 本人拖。抓取诊断每周 70 次，可以用来看百度蜘蛛实际读到的内容。「普通收录」页面上的 API 推送密钥是凭据，不写进仓库；以后要在部署后自动推送给百度，再另行设计。
- **部署后自动推送**：`scripts/deploy.sh` 部署正式站成功后，把这次有变化的地址推送给 IndexNow（Bing、Yandex、Naver、Seznam 等共用一个接口，凭据是站点根目录的一个密钥文件，不需要账号）；推送失败只提示，不影响部署。Google 不支持 IndexNow，靠 sitemap；百度的推送接口需要它站长平台的凭据，不做。实现：
  - **密钥文件**：`static/indexnow.txt`，发布在根目录 `/indexnow.txt`，内容只有密钥本身（32 位十六进制，不带换行）。放在根目录，作用范围才覆盖全站；推送时用 `keyLocation` 指向它。密钥本来就是公开的。站点规则第 2 段把它列进 `@static`，按原样提供（`text/plain`、`no-cache`，与 robots.txt 相同）；合同表核对它的内容就是密钥，换密钥时两处一起改。
  - **推送什么**：只推内容有变化、且应当收录的页面。`scripts/indexnow-urls.py` 经 ssh 从标准输入交给服务器上的 python3 运行（不必安装到服务器上，脚本取自这次部署的提交）：读新版本的 sitemap，逐个逐字节比较切换前后两个版本目录里同一地址对应的页面文件（`…/index.html`），输出内容不同或上一版没有的地址。sitemap 不列带 noindex 的页面（4.10），所以列在里面就是应当收录的。没有可比较的上一版时（首次）每个页面都算新增，推送全部；没有变化就不推送。CSS 指纹一变，所有页面的 HTML 都跟着变，这时全推，不另作处理。
  - **什么时候推**：只在正式站部署成功之后，也就是 URL 合同与 `desktop2.json` 的核对都通过、没有回滚。`--staging`、`--rollback` 与失败的部署都不推送；桌面版 release.sh 的部署同样会推送。
  - **怎么推**：一次 POST 到 `https://api.indexnow.org/indexnow`，JSON 体含 `host`、`key`、`keyLocation`、`urlList`，超时 20 秒，用本机的 curl 与 jq。200 与 202 算成功，打印推送了几个地址与状态码；其余状态码与网络错误只打印一行提示，部署结果与退出码不变（照旧为 0）。
  - **手动入口**：`scripts/deploy.sh --indexnow-only`，把正式站当前版本 sitemap 里的全部地址推送一次，密钥也取自当前版本；用于自动推送失败后补推，以及首次验证。不重算差异：补推时不一定说得清该与哪一版比，全站只有三十来个地址，全推一次也无妨。失败时以 1 退出。
- **站点名**：定为「纯纯写作」，四个名字同时写进 WebSite 的别名与每页的关键词（4.10）。
- **官方账号**：Telegram 频道 `https://t.me/PureWriter` 与微信公众号「Drakeets」。首页的 SoftwareApplication 用 `sameAs` 写 Telegram 频道与 App Store、Google Play 的应用页；公众号没有公开的网页地址，写不进 `sameAs`，只写进 `llms.txt`。不另写 Organization：各市场的运营主体不同（简体中文页面是苏州小白迷雾科技有限公司，其余语言与 App Store 上的 iOS 版是 Drakeet Co., Ltd.，见 10.1 第 1 条），官方账号属于产品，挂在产品上即可。
- **分享卡片大图**：五种语言的首页改用 1200×630 的分享图：从 App Store 产品页的页头（雾山稿纸加「写作，连接过去，遥想未来。」）截取，左上角补上图标与名称，由 `scripts/og-images.py` 生成到 `assets/img/og/`，港繁共用台繁一张；构建时加内容指纹、原样发布为 JPEG（不少平台不认 WebP 的分享图），页头写明尺寸。下载页沿用桌面版截图的大卡片，其余页面仍是图标小卡片。微信不读这些标签，不受影响。旧的分享图（`images/header_zh_hans.jpg` 等）在固定字节清单里，照旧保留。
- **CAA 记录**：`writer.drakeet.com` 与 `writer2.drakeet.com` 各写两条 `0 issue`，分别是 `letsencrypt.org` 与 `sectigo.com`（Caddy 的兜底 ZeroSSL 由 Sectigo 签发）。CAA 只往上级域名查找、不影响同级，所以不影响 drakeet.com 的其他子域。根域名 drakeet.com 虽是指向 writer 的 CNAME，但阿里云权威 DNS 对根域名的 CAA 查询回 NODATA（只有 SOA），不会跟到 writer 的 CAA，其他子域名查到的仍是空；api.drakeet.com 现用的也是 Let's Encrypt（2026-11-08 核对）。以后若在根域名上加 CAA，就会约束所有没有自己 CAA 的子域名，届时先盘点各子域名所用的 CA。2026-11-07 已在阿里云解析添加，权威 DNS 上可查到。
- **内容打磨**：结构化数据与 `llms.txt` 的内容打磨；各语言标题与描述的质量检查，除首页外统一为「页面名 - 品牌名」；用 Lighthouse 对各语言首页与下载页做一次无障碍与性能体检。
  - 2026-11-07 体检（PageSpeed Insights，移动端，简体首页）：性能 91、无障碍 95、最佳做法 100、SEO 100；真实用户的 Core Web Vitals 通过（LCP 2.2 秒、INP 101 毫秒、CLS 0）。
  - 无障碍扣分的是「链接只靠颜色区分」，正文链接已加淡下划线（c777135c）。
  - 「样式表阻塞渲染」不处理：压缩后只有 1.7 KB，内联要连带改 URL 合同里检查 `/css/` 的几行；国内访问慢的主因是 JAR 下载挤占出口，由第九节 H 解决。
- **2026-11-12 实测与跟进**（新站上线五天后，查 Google、必应、百度的实际结果与 Search Console 的数据）：
  - **Google 把本站的站点名显示成「OCAT App」**（桌面版页面显示「drakeet.com」，标题后被加上「- Drakeet」）。原因有两层：Search Console 的网址检查里，根地址 `https://writer.drakeet.com/` 是「Google 不知道的网址」（站内链接与 sitemap 都只写带语言前缀的地址，没有任何地方引用根地址），所以 Google 还没有从根地址的跳转目标读到 WebSite 数据；取不到子域名的站点名时退回主域名的，而 drakeet.com 当时 301 到 ocat.app。处置：drakeet.com 与 www 改为 301 到本站的根地址（5.7，已上线）；在 Search Console 对根地址请求编入索引（已提交）。Google 的文档写明首页跳转时站点名按跳转的目标读取，重新抓取要几天到几周。观察到 12 月上旬仍不对的话，再考虑让根地址对不带 Accept-Language 的请求直接返回简体首页（200，canonical 指向 `/zh-hans/`），那要改站点规则第 5 段与合同。
  - **Search Console 的数据**（8 月中至 11-10，共 35 次点击、216 次展示）：查询词以「pure writer desktop」「pure writer pc」「純純寫作電腦版」「纯纯写作电脑版」为主，而桌面版页面里「电脑版」「PC」一次都没有出现。处置：六种语言的桌面版页面在描述里带上本语言的说法（电脑版、電腦版、PC 版、PC and Mac、ПК），三种中文在副标题里再出现一次。未编入索引的只有 3 个：`/ios/support`（跳转，正常）、`/markdown` 与 `/zh-hans/markdown/`（已抓取、尚未编入）。
  - **百度**：品牌词第一条是本站，显示的是根地址。相关搜索是「纯纯写作app官网」「纯纯写作下载」「纯纯写作有没有苹果版」「纯纯写作pc版」「纯纯写作会员值得开吗」「纯纯写作app怎么用」。处置：五种语言首页的标题由「文本编辑器」改为「写作软件」一类用户真正搜的词，描述以「纯纯写作（Pure Writer）官方网站。」开头并补上电脑版；新增 iOS 版介绍页（4.4），常见问题里回答「有没有 iOS 版（苹果版）」。价格不公开（Drakeet 定），「会员与价格」一节不做。`site:` 查询被验证码拦住，内页的收录情况没有核实。
  - **英文品牌词「Pure Writer」**：Google 首页没有本站，是 2019 年的评测、下载站与 Reddit；AI 概览引用的是第三方页面，说它主要面向 Android，没有提 iOS 版。处置：GitHub 上 `PureWriter/desktop`（README 还写着划掉的旧地址）与 `PureWriter/PureWriter` 的 README、主页与简介改为指向本站对应的页面。Google Play 的开发者网站本来就是本站。其余自有渠道（App Store 的营销网址、Microsoft Store 条目、Medium、Telegram 频道简介）由 Drakeet 酌情更新。
  - **`/ios` 入口**：不带语言的 `https://writer.drakeet.com/ios` 按访客语言协商到各语言的 iOS 版介绍页（站点规则第 5 段的 core 入口），适合填作 App Store 的营销网址与对外张贴。
  - **查过、不做**：软件应用的星级富媒体结果（Google 不允许引用其他网站的评分，应用商店的评分不能用）；把手册拆成多页（App 在深链手册的锚点，单页必须保留，另拆专题页会造成重复内容）；三份隐私政策的标题（Drakeet：暂不改）。FAQ 结构化数据当时也列在这里（Google 已基本不再展示），后来为 AI 检索做了，见下面「面向 AI 的可读性」。
  - **iOS 版介绍页的「为什么通过 Google Play 购买的会员不能转到 iOS 版」一问**（锚点 `#google-play`，五种语言）：Drakeet 亲自写的说明，讲两家商店的付费为什么不能互通（互通要求人人注册账号、订阅状态难以持续同步、兑换码无法核销、有账号与无账号两套体系并行）。回复这类询问时可以直接给这个地址。
  - **上线与提交抓取**：785d6e7 在 2026-11-12 部署到正式站，合同 519 行全过，IndexNow 推送了 39 个地址。当天在 Search Console 请求编入索引的有：根地址、五个语言的首页、简体与英文的桌面版页面。检查时发现英文首页 `/en/` 与英文桌面版页面当时都是「已发现、尚未编入索引」，这就是英文品牌词搜不到本站的直接原因。Search Console 每天能提交的数量有限，其余页面靠 sitemap。
  - **面向 AI 的可读性**（2026-11-12，在上一项上线之后做，见 4.10 与 content.md 第九节）：现状是 robots.txt 对所有爬虫放行，用 GPTBot、ClaudeBot、PerplexityBot、Bytespider、Baiduspider 的 UA 请求线上都是 200，所以不逐家列出爬虫；`/llms.txt` 已有，`/llms-full.txt` 是 404；结构化数据只有 WebSite 与 SoftwareApplication。这一轮：
    - 新增 `/llms-full.txt`：英文首页的自定义输出格式 llmsfull（`hugo.toml`，`root` 发布在根目录），模板 `layouts/index.llmsfull.txt` 按固定顺序取英文的首页、iOS 版介绍与支持、桌面版下载页、使用手册、备份教程，再附简体独有的 Markdown 教程、保护机制、请使用正版三页，由 `layouts/partials/llms-markdown.html` 经 Hugo 自带的 `transform.HTMLToMarkdown` 转成 Markdown；开头的概述取自 `llms.txt`。不从 Markdown 原文拼：原文里的 `{#id}`、shortcode、原样 HTML 与相对链接都要处理，还要避开手册代码块里的 Markdown 示例。2026-11-12 的产物约 173 KB；
    - `llms.txt` 加上 llms-full.txt 的入口，补上漏列的 Markdown 教程、保护机制（Help）与请使用正版、开发故事（Optional），其余不变；
    - iOS 版介绍页五种语言的「常见问题」h2 加上 `id="faq"`，FAQPage 从这一节解析（4.10），页面的可见文字不变；
    - 站点规则第 2 段的 `@static` 加上 `/llms-full.txt`，合同加三行（原样 200、带语言头与 `?lang=` 不协商、预压缩），`/llms.txt` 那一行改为核对 `charset=utf-8` 与指向 llms-full.txt 的链接；
    - 不在页面的 `<head>` 里加发现链接：llms.txt 没有约定这类 `<link>`。
  - **之后要看的**：Google 的站点名是否由「OCAT App」变为纯纯写作（见上，12 月上旬为限）；`/en/` 与各语言 iOS 版介绍页是否编入索引；必应读到的 sitemap（导入当天还在处理中）；上线后访问日志里有哪些爬虫读取 `/llms.txt` 与 `/llms-full.txt`（按 UA 聚合，operations.md 5.4）。
- **不做**：IPv6（阿里云的 IPv6 公网带宽另外收费，需要付费的一律先不做）；境内的外部监控（GitHub Actions 从境外访问本站是通的，足够）。

### F. 使用手册全面检查与翻新

旧手册里有许多说法已经过时。例如「不购买纯纯写作的高级版可以正常使用吗？」一条：iOS 版现在采用试用期后统一付费解锁的方式，与旧的回答不符。按 Drakeet 2026-11-07 的要求，手册迁移完成后立即开始（不等重建全部完成），以逐字迁移、比对通过的手册为底本：

1. 逐条对照 Android、iOS、桌面三端的现行行为与各仓库文档，标出过时、错误或缺失的问答，证据写明出处。
2. 按核对结果改写简体版。文案口径遵守 iOS 仓库的约定，例如术语、称呼用户用「您」、全角标点。
3. 再据此重做繁体（台湾）、繁体（香港）、英文、日文等版本：补齐英文版缺的 16 条，繁体改为规范的台港用词，从「旧版」名单与市场例外里移除。
4. 改完请 Drakeet 过目再上线。

### G. 后续

- ~~drakeet.com、www.drakeet.com 与 DeepOCAT 旧页~~：2026-11-08 起一律 301 到 ocat.app，根域名的解析改为 A 记录（5.7）；
- ~~请 ocat.app 改为自己托管那 5 张图片~~：2026-11-08 完成（OCAT 仓库 `pages/ocat` 的 440b408，图片放在 ocat.app 的 `/images/`）。本站的 5 张照旧按原路径、原字节保留，旧的缓存页面与社交平台的预览可能仍在引用；
- rebase-server 的可选简化（暂不做，rebase-server 81a047c5 在 `Drives.kt` 与 `RawJsonResource.kt` 里加了注释）：指的是把 rebase-server 里官网的旧地址（授权完成页、`/desktop2_zh` 等）改成新地址，省一次跳转。旧版客户端仍会请求旧地址，网站的兼容规则无论如何都要保留；改了用户感觉不到，还要多部署一次服务端；
- 补齐滞后的译文（第十一节）；
- ~~个人代理服务按需重装~~：2026-11-08 用 Ubuntu 官方源的 shadowsocks-libev 重新部署，只开 TCP 8621，见 operations.md 第 10 节；
- 桌面版 CI 从镜像兜底下载 JAR 时不校验哈希（既有问题），可以改为校验 JarVersions 或 R2 给出的哈希；
- 收回免密 sudo（5.3 的终态）。

### H. 出口分流（Drakeet 2026-11-07 定，紧接在原计划之后进行）

设计、合同、任务清单与验收写在专项正本 [egress-offloading.md](egress-offloading.md)；本节保留 Drakeet 定下的方向。

起因见第十一节「出口带宽被 JAR 下载占满」：发版后的高峰里 JAR 占出口的 83%，`/images/` 占 16%，网页只占 0.5%。本站在境内，全世界都能访问；Cloudflare 在中国部分地区连不上，所以不能一刀切，要按情况给不同的来源，本站作为兜底。两头一起做：

1. **兼容旧版桌面版，只改 rebase-server**：按设备自动回落。报告 GitHub 可达的设备照旧给 Cloudflare 上的地址（kuromi.drakeet.cn，即 R2）；其余设备先给 Cloudflare，同一台设备之后再来检查、仍停在旧版本，说明没下成，改给本站镜像；去掉现在按时间奇偶抛硬币的做法（`JarVersions`，`RawJsonResource` 里已有的 `kuromiHitMap`）。部署 rebase-server 由 Drakeet 执行。
2. **新版桌面版自己选来源**：服务端同时下发多个来源（Cloudflare 在前，本站镜像在后），桌面版先试 Cloudflare，连不上或太慢就换镜像，已下载的部分断点续传。生成这些链接的脚本（桌面版发版时写 JarVersions 的那一步）一并调整。
3. **旧图片**：把 `static/images/` 原样上传到 R2 的 kuromi 存储桶里的 `writer/images/` 下，子路径与站内一致（例如稿纸背景是 `writer/images/papers/0.jpg`），客户端把 `writer.drakeet.com/images/` 换成这个前缀即可。用层级与存储桶根目录的 JAR 分开（Drakeet：目录用层级表达，不用短横命名），以后清理 JAR 时不会误删；上传后按 `ops/images.sha256` 核对字节。Android 新版本加载这些图片时先试 Cloudflare 上的副本，失败再回到本站；旧版本与站外引用照旧从本站取，本站的 `/images/` 继续原样提供。
4. **发版高峰**：可以考虑分批推送更新，把下载摊开。
5. **验收**：下一次桌面发版后的高峰里，本站出口中 JAR 的占比明显下降，网页的加载时间随之改善。

## 十、待 Drakeet 定的事项

Drakeet 2026-11-07：借重建之机全面翻新整顿，发现不规范、能做得更好、能向最佳实践迁移的地方都提出来。不改文案的技术与结构改进直接做；涉及文案、产品口径或需要拍板的，列在 10.1，分批请他定。

### 10.1 翻新建议（文案与内容）

| # | 问题 | 证据 | 建议 | 状态 |
|---|---|---|---|---|
| 1 | 公司署名四种写法 | 首页与下载页「苏州小白迷雾科技有限公司」，iOS 页「Drakeet Co., Ltd.」，英文 Android 与桌面隐私政策「Drakeet, Inc.」，日文旧首页「ドラキート株式会社」。新站的简体 iOS 支持页与隐私政策上，正文署名 Drakeet Co., Ltd.，全站页脚又写着「版权所有：苏州小白迷雾科技有限公司」，同一页出现两个主体 | 简体中文写「苏州小白迷雾科技有限公司」，其余语言（含日文）写日本公司的英文名「Drakeet Co., Ltd.」。例外：iOS 版在 App Store（中、日、美区）的销售商是 Drakeet Co., Ltd.，简体的 iOS 隐私政策与支持页正文、署名照旧写它，页脚用 front matter 的 `company` 跟着写它（docs/content.md） | 已完成（4d613af）：英文 Android 与桌面版政策改为 Drakeet Co., Ltd.，更新日期 2026-11-08；非简体页面本来就不输出页脚 |
| 2 | 「请使用正版」页过时 | 「纯纯写作 98% 的功能都是免费的」与 iOS 统一付费不符；隐私政策链接指向 GitHub 上的旧文件；下载只给小米商店 | 简化：只留「请从官方渠道下载、不要信任破解版」，下载与隐私政策指向官网各端的页面，删去过时的说法 | 已完成（a5abd92）；只有简体中文一种语言 |
| 3 | 几篇长文过时 | 保护机制停在 2019 年；繁体备份教程是 2022 年前的旧版；英文备份教程停在 2023 年；英文 Android 隐私政策缺两段 | 长文简化、概括：删去过时或无法核实的具体说法，留下仍然成立的要点；隐私政策缺的实质披露译成英文补齐 | 已完成：繁体、英文备份教程随第 F 步重做（fc0b13d）；保护机制概括重写（a5abd92）；英文 Android 隐私政策实际缺三段（Basic Statement 的读取局域网 IP、账号邮箱两条，第三方 SDK 的支付宝 SDK 一条），都是实质披露，已补齐（d916be2） |
| 4 | 网盘授权完成页的英文、韩文机翻腔 | 「Please return to Pure Writer client on your own」「자체적으로 … 돌아가십시오」 | 重译这两句（4.6） | 已完成（e6012af） |
| 5 | 下载页的英、日、俄版本没有链接开发故事 | 简繁有微信原文链接；英文开发故事 /en/blog/new-desktop-dev-story/ 现成 | 维持现状，不加链接 | 已定 |
| 6 | DeepOCAT 三页说法矛盾 | 介绍页「不收集任何隐私信息」，隐私政策页列出收集的数据 | 与 drakeet.com 一起 301 到 OCAT 的官网 ocat.app（5.7） | 已完成（4ae9f85）：旧页从本站删除；drakeet.com 的规则 2026-11-08 已装到服务器 |
| 7 | 手册推荐的 TeraCLOUD 已更名 | teracloud.jp 证书过期，服务 2023 年改名 InfiniCLOUD | 并入第 F 步 | 第 F 步 |
| 8 | 非简体首页的网盘清单删掉了阿里云盘 | 台繁、港繁、英、日四个首页都只列 Dropbox、OneDrive；旧首页页头注释把「阿里云盘」扩大成只限简体（与 AGENTS.md 的约定不一致）；新规则允许各语言列出它，iOS 隐私政策五种语言都列了 | 四个首页的网盘清单恢复阿里云盘，与 App 一致 | 已完成（b693ec2）：繁体写阿里雲盤，英、日写 AliyunDrive（App 里的叫法）；AGENTS.md 写明阿里云盘可以出现在各语言里 |
| 9 | 「获奖情况」只出现在三种中文首页 | 调研报告 4.1 | 维持现状 | 已定 |
| 10 | 简体 iOS 隐私政策的一处说法与其他语言不一致 | 「六、保存期限与删除」写「账号信息：保存至您注销账号为止」，同节下文与其他四种语言都说删除账号（刪除帳號、delete your account、アカウントを削除） | 改为「删除账号」，与 App 里的叫法一致；措辞对齐的编辑性更正，不改页面日期 | 已完成（9a83ce4）；iOS 仓库 docs/privacy.md 里没有「注销账号」的说法 |
| 11 | 简繁备份教程的截图过时 | 第一张截图的红字仍是「从此万无一失，一劳永逸」，与 2026-10 去掉「万无一失」的方向不一致。截图里露出的邮箱不必处理：Drakeet 2026-11-07 确认他的邮箱本来就在许多地方公开 | 随第 3 条重做备份教程时决定是否换图 | 已完成：重写时删去了坚果云的三张截图（fc0b13d） |
| 12 | 英文备份教程的明显错误 | 标题拼成「Bakup」；两处「Documents/PureWriter/Backups that you manually click」一类的替换事故；仍有 2026-10 已从其他页面去掉的结果承诺 | 并入第 3 条 | 已完成：英文备份教程已重写（fc0b13d） |
| 13 | 几处小的排版错误 | 日文首页「透かしの文字やEPUB」缺空格；英文、俄文下载页「Other downloads:」「Другие варианты:」冒号后没有空格，读屏会连读成一个词 | 文案批次顺手改 | 已完成（b693ec2） |

### 10.2 其他待定事项

1. **桌面版的旧问题**（已定：不改安装包）：Windows 安装包写进「已安装的应用」的更新链接是坏的（2.1）。网站已把这类地址跳到桌面版下载页（站点规则第 6 段），存量安装本来就只能靠网站兜底；根治要改 MSI 的代码页（运行中拦截的三语文案依赖 65001）并在 Windows 上实测，安装器出错会让用户装不上，代价远大于收益。

已定的事项不再列出：过渡期工作目录、工具下载、备案号、不做快照、不做演练、由我在 Chrome 里操作阿里云控制台、带宽保持 2 Mbps 固定、HTTP/3 安全组规则（已添加）、ACME 联系邮箱用 writer@drakeet.com（已登记到账户）、外部监控用 GitHub Actions、部署与服务器的说明放在 `docs/operations.md`、iOS 隐私政策的页面日期（写这一版上线生效的 2026-11-05，编辑性更正不改日期；实质变化的英文 Android 与桌面版政策写 2026-11-08）。

## 十一、已知问题与后续（本轮不做）

- **滞后的译文**：
  - `wiki_en` 缺 16 条问答；
  - `backups_en` 停在 2023 年；
  - `wiki_zh` 是机械的简转繁，并兼作香港版；
  - `privacy_en` 缺两段；
  - `backups_zh` 落后于 sources/ 原稿。

  本轮按线上版本原样迁移，留待文案批次处理。之后都已处理：手册与备份教程随第 F 步重写，`privacy_en` 补齐了缺的段落（10.1 第 3 条）。
- **违反市场约定的旧内容**：`backups_zh`、`wiki_zh` 里有只适合大陆用户的内容。第 C 步时原样迁移，构建检查只给提示；第 F 步重写手册与备份教程后已不含这类内容，「旧版」名单清空，两页按常规规则检查。
- **Azure 注册里的网页回调**：`https://writer.drakeet.com/drives/one` 仍在使用，保留。2026-11-08 核对：现行的 Android 与 iOS 用 `www://` 回调，桌面版用 api.drakeet.com 的地址，都不经过它；但旧服务器 9～11 月的日志里一直有真实用户的浏览器带着 `?error=…` 被跳回这个地址（微软只跳回已登记的地址），来自 Android、Windows、ChromeOS 与 Linux，说明仍有旧版客户端在用，删掉会让这些版本无法授权。本站对它回 404，与旧站相同；以后可以考虑放一个「授权没有完成，请回到纯纯写作重试」的提示页。
- **隐私政策与相关的数据处理（先记账，网站重建完成后单开一个系列统一审视，Drakeet 2026-11-07 定）**：新站上线的隐私政策停在 2026-11-07 这一版（Android 不写 AI，只写一句「部分功能可能另行提供条款」；桌面版补上了使用统计、设备信息、网盘账号、阿里云盘与检查更新）。此后只按 10.1 改过几处：英文 Android 与桌面版的署名、英文 Android 补齐缺的段落（这两份的更新日期因此是 2026-11-08）、iOS 版的页面日期与一处用词；其余这一轮不再继续改。核实时发现、留给那个系列的：
  - 桌面版发给我们服务器的请求都带系统主机名作为电脑名（常含用户的名字），检查更新时服务器记进 `desktopDevices`。方向：只带随机生成的设备标识，改完再从政策里删掉这一项。
  - 服务器上留着以「阿里云盘 + 手机号」为键的旧版同步索引，不设自动删除；老用户升级时 V2 迁移还会把旧键发给服务器一次。方向：迁移完成后删除。
  - 阿里云盘续期把 refresh token 放在 GET 查询串里，访问日志可能留下它（iOS 仓库 docs/privacy.md 的 BACKUP-013 已登记改为 POST）。
  - AI：服务端在请求入口把最后一条消息的正文连同邮箱与 Android ID 写进运行日志（rebase-server `AIResource.kt` 的 timber 几处），计划改为不记正文；请求的 user 字段带原始 Android ID，自填的第三方服务也会收到。
  - Android 发往我们服务器的请求头（设备标识、型号、MCC、安装来源、网盘类型、邮箱等）与服务器访问日志（IP），Android 与桌面版的政策都没有完整写（Android 英文政策缺的几段已补齐，与简体一致，10.1 第 3 条）。敏感词的上报按政策要求不写进隐私政策。
  - 安全：rebase-server 的源码里写死了几把第三方 AI 服务的 API Key，应改用配置文件或环境变量，并更换这些 Key。
  - 出口分流（第九节 H，egress-offloading.md）：Android 新版本加载官网旧图片时先访问 Cloudflare 上的 kuromi.drakeet.cn，请求不带设备与账号信息，只有 OkHttp 的默认请求头；写进政策时列入第三方 CDN。桌面版的 JAR 下载用到的两个地址与以前相同。另记一条既有事实：Android 经 Glide 请求官网图片时带系统的 User-Agent（含机型、系统版本与构建号），一直如此。
- **Android 与桌面版的文案问题（手册重写时发现，与手册无关）**：
  - Android「会员须知」仍写 3 台设备，服务端与 iOS 条款是 5 台；
  - Pro 页把已免费的 Material Design 2 列为 Pro 功能；自定义稿纸与批量替换的付费框里，「试用」按钮点了不能继续；
  - 「注销纯纯写作账号」设置项与对话框、「无法启动 Google Play 支付」的提示在所有语言下都写死简体；英文的 once 译成了「ever」；「忘记密码?」用的是半角问号；
  - 「自行提供的国产 AI 服务」未填地址时默认发往 api.openai.com，名称与行为不一致；英文的 aiEntrySummary2 说用 OpenAI 等的模型，与实际（火山方舟上的 DeepSeek）不符；
  - 桌面版的繁体文案（CN_TW）里有大陆或香港用词，例如「屏幕」「登錄」「搜索」「查找」「正則表達式」；桌面版的云同步说明与 Android《关于云同步》也已落后于代码。
- **出口带宽被 JAR 下载占满**（2026-11-07 实测，桌面版 5.1.0 发布两天后）：
  - 新服务器上线后约 6 小时，正式站出口共约 3959 MB，平均 1.4 Mbps，接近 1.9 Mbit 的整形上限。其中 JAR 占 83%（107 个 IP），`/images/` 占 16%，网页只占 0.5%。
  - CAKE 按客户端主机平均分配出口，同一时段有十几台主机在下载 JAR 时，打开网页的访客只能分到一小份，100 KB 的页面要好几秒；部署的上传也因此变慢（第一次整站上传 9.7 MB 用了约 10 分钟）。
  - 改进方向（Drakeet 提出借助 Cloudflare 分担，前提是照顾到部分地区连不上 Cloudflare）：
    - JAR：rebase-server 的 `JarVersions` 已经在分流，报告 GitHub 可达的设备给 Cloudflare 上的地址（kuromi.drakeet.cn，即 R2），其余按时间奇偶各给一半 Cloudflare、一半本站镜像。可以改成按设备自动回落：先给 Cloudflare，同一台设备下次检查时仍停在旧版本，说明没下成，再给本站镜像（`RawJsonResource` 里已有记录这件事的 `kuromiHitMap`，还没用于决定）。这样只改服务端，本站只承担确实连不上 Cloudflare 的设备，R2 的出口不收费。更进一步是让桌面版自己先试 Cloudflare、连不上或太慢再换镜像，并且分批推送更新，把发版后的高峰摊开；
    - `/images/`：Android 稿纸背景存的是完整地址，旧版本只能继续从本站取；新版本可以先试 Cloudflare 上的副本、失败再回到本站；
    - 网页留在本站（备案、国内访问速度与 SEO）。
  - 这些都在 rebase-server、桌面版与 Android 里改，已排入第九节 H，紧接在原计划之后进行。

## 十二、评审记录

### 2026-11-07 第一轮（方案初稿 051192f；五个视角的对抗复审，共 64 条）

复审视角：URL 合同、服务器与运维、本地化与 SEO 合规、简洁与可维护性、与各端流程的衔接。完整意见存于本机 `evidence/website-rebuild-2026-11/review-1.json`。

**采纳**：

- **JAR 镜像的保留数**：四个视角一致认为「只留最新两版」会删掉服务端仍在下发的版本。采纳，改为保留最近 7 个版本（5.6），首次同步取 R2 上现有的全部版本。依据「先问是否正确」：「最新」应以已部署的 rebase-server 为准，而同步脚本无从得知它，留出富余的计数是最简单也正确的做法。
- **地址补漏**：Windows 安装包的坏链接别名；不带尾斜杠的目录式旧地址与三个历史地址；杂字符的通用清理规则；首页旧锚点与三种语言的手册锚点；撤下仍被引用的横幅与 precomposed 图标。各项都有日志数字支撑。
- **语言规则写清**：规范化函数（4.5）；协商时目标页没有的语言直接跳过；多语言入口与单语言旧地址的区分；`/desktop2_zh` 在两种繁体之间协商；切换器规则（4.3）。
- **x-default 改为指向英文版**：按原写法，Google 收录的 x-default 会是简体中文页。
- **Hugo 的隐式行为**：用扁平叶子包与 `url` 表达嵌套地址，关掉多余的页面类型，覆盖内置的 head 与 sitemap 模板，加期望产物清单。
- **服务器与运维**：
  - 初始化顺序与收尾后的权限终态（5.3）；
  - 主机密钥经云助手核对，并排在初始化之前；
  - Caddy 日志的保留与权限；ACME 邮箱；`Restart=on-failure`；
  - 外部监控改为必做；
  - 停机按 60 分钟沟通，两段式初始化；
  - `writer-jars-sync` 的参数校验、权限、绕过缓存、幂等与续跑入口；
  - 跳转码接受 Caddy 默认的 308。
- **站点规则随版本发布**（5.3）：日常改跳转不需要 root，规则与内容一起回滚；管理接口收进 unix socket。
- **部署流程**：
  - 从已提交的 HEAD 构建；
  - 合同检查改为在服务器上运行、失败自动回滚，不再每次构建都启动本机 Caddy；
  - 与时间有关的检查只告警；
  - 字节哈希在服务器本机核对。
- **过渡期**：定期把 `master` 合进 `rebuild`、切换时快进；release.sh 预检拦下未推送的他人提交；首次生产部署从 `rebuild` 显式放行；窗口内冻结桌面发版。
- **做减法**：
  - 删掉语言 cookie：受益的人极少，成本压在最复杂的协商配置上；在站内导航时，语言已经由 URL 保持；
  - 删掉 Markdown 版页面与 IndexNow：没有可验证的收益，后者还会在部署路径上多一次外部调用；
  - 删掉韩文站点语言：授权完成页合并为每家一页、五语并列；
  - HSTS 直接设一年；404 不做协商；样式允许内联；security.txt 的 Expires 在构建时生成。
- **其余**：市场检查改查构建产物、按词组豁免；备案写进合同检查并居中；JSON-LD 不写不准的价格、补上 WebSite；iOS 支持页与隐私页保留智能横幅；Google OAuth 同意屏幕的地址在切换后更新。

**不采纳或改为别的做法**：

- **用快照做回滚**：阿里云账号没有开通快照服务，Drakeet 也表示服务器上的不可逆操作不要紧；换系统前，服务器上独有的数据都会拉回本机。服务器上于是没有不可再生的东西，回滚就是重做（5.1）。又改为「先换服务器、后换网站」，新站切换本身不停机，快照能保护的风险基本不存在了。
- **改用 nginx 以避开 Caddy 的升级风险**：保留 Caddy，改为受控升级（先用新版本校验配置，装上后自检，失败自动装回）。依据：这样既保住了 Caddy 少一个组件、更现代的默认值，也消除了「补丁版带破坏性变更」的风险。nginx 方案同样可行，作为备选写在 5.2。
- **关掉 HTTP/3**：保留。理由：国内移动网络丢包多，HTTP/3 对用浏览器打开页面的访客有实际帮助；安全组规则已经加好；ufw 规则写在初始化脚本里，两处规则记在运维手册的同一张表里，不会长期不一致。
- **本机 Lima 演练**：删掉。复审指出它验证不到阿里云镜像自身的差异，改为第 A.2 步的临时实例演练（待确认费用）；本机只用 Caddy 二进制检查规则。
- **保留语言 cookie**（本地化视角认为无害）：与简洁视角冲突，按「先问是否必须」采纳删除。浏览器语言与偏好不一致的少数用户，从无前缀入口进站时多点一次切换器即可。若有用户反馈，再加回来。

### 2026-11-07 第二轮（第 A 步的服务器脚本、旧站规则与桌面版补丁；四个视角的对抗复审）

复审视角：初始化会不会把自己锁在外面、脚本正确性、与桌面版的衔接、安全与最小暴露面。完整意见存于本机 `evidence/website-rebuild-2026-11/review-2.json`。复审与窗口同时进行，必改与应改项在执行 `ssh`、`harden` 两步之前并入了脚本。

**采纳**：

- **以 root 运行 `caddy validate`**：校验会把日志文件建成 root 所有，Caddy 随后起不来（窗口里实际踩到，当场修正）。改为以 caddy 身份校验，受控升级脚本同样处理；后者在收尾之后还等于留了一条免口令提权的路（站点规则 drakeet 可写，root 校验时日志的 `mode` 可以改任意文件的权限），一并消除。
- **drakeet 不在 sudo 组**：收回免密 sudo 之后它将没有任何 sudo，root 又不能 SSH 登录。加入 sudo 组；免密 sudo 只在 drakeet 还没有口令时安装，收尾后重跑 `users` 不会装回；收回的步骤改为保留一个 root 会话、验证口令 sudo 之后再关（operations.md 第 9 节）。
- **收紧 SSH**：之前先确认 sudo 可用；`sshd -t` 不通过就撤回片段，免得 sshd 下一次重启时起不来。
- **初始化的顺序与幂等**：harden 先建 swap 再升级；显式设定时区；定时器先于出口整形启用；caddy 只在未安装时安装，hold 之后重跑 `web` 不再被拒；`provision.sh` 设为可执行。
- **受控升级**：安装失败也会回滚并重新 hold（函数在 `if` 条件里调用时 `set -e` 不生效，改为显式传递退出码）；自检加上「不存在的路径应为 404」。
- **openrsync**：不认 `--chmod=D755,F644`，改为在本地统一权限；顺带把「未变的文件做硬链接」做成真的（按内容比较、不保留时间）。
- **旧站仓库**：`.gitignore` 的 `*.sh` 为 `scripts/` 放行；deploy.sh 在切换之前取好期望的版本号；404 不再带图片与 JAR 的长缓存头。
- **release.sh**：官网仓库的检查不论从哪一步开始都执行（`--from deploy` 发布的是本地 HEAD，原写法会绕过未推送检查）；预检同时确认服务器端脚本已就绪，不再屏蔽 ssh 的报错；完成提示指向 /desktop。`buildAllJars.sh` 镜像相关失败的续跑提示统一。
- **验证方式**：A.5 改为 `--from site --dry-run` 加 `--sync-only`；部署成功后立即推送 `master`。
- **其余**：writer-release 的 KEEP 注释与实现对齐；安全组里遗留的 8621 删除，与 ufw 一致。

**不采纳或改为别的做法**：

- **首装固定 Caddy 版本**：不采纳。`web` 在启动前以 caddy 身份校验配置，新版本不认现行配置会当场停下，之后的升级都走受控升级；固定版本要另外维护一个版本号，收益抵不上成本。
- **去掉 `AllowTcpForwarding no`**（理由是对唯一账户几乎不缩小暴露面）：保留。它是加固的默认值；Drakeet 以后若想用 `ssh -D` 代替个人代理，改一行即可。
- **受控升级的自检改为完整合同**：方向采纳，放到第 B 步与合同表一起做（5.5），本轮只加 404 一项。
- **证书私钥与代理口令不要存进 evidence/**：核对后，备份里没有证书私钥；代理配置是恢复 Drakeet 个人代理所需，保留在权限 600 的备份里。
- **桌面版 CI 从镜像兜底下载时不校验哈希**：既有问题，记入第 G 步。

复审时未能核实的几点已在窗口中得到验证：openrsync 推送到服务器上的 GNU rsync 正常；sudo-rs 的 `visudo -cf` 与 `@includedir` 正常；阿里云 26.04 镜像的时区是上海。

### 2026-11-07 第三轮（新站的站点规则、URL 合同与部署脚本；对抗测试、主持方复审与两轮 GPT 复审）

过程：主程实现 → 三个视角的对抗测试（地址与旧服务器 52 天日志重放、语言协商与参考实现比对、响应头）→ 修复 → 主持方复审与本机复测 → GPT（gpt-6-astra）复审 → 修正轮（主程实现，站点规则、部署与构建两个视角核验，再修正）→ GPT（gpt-6.1-sol）核对修正 → 小修。GPT 的答复与逐条处置存于本机 `evidence/website-rebuild-2026-11/caddy-review/`。

**采纳**：

- **不规范的路径**：`//wiki`、`/./desktop_zh` 这类写法原来会 404，旧站与现网都回 200（52 天约 105 次）。改为按清理后的路径处理。
- **`lang` 参数**：有多个同名参数时，Caddy 把它们的值用逗号连起来，语言按后一个定。改为从原始查询串取第一个，取值与去掉用同一个口径。
- **错误响应**：
  - 405 沿用了预压缩副本的 Content-Encoding 与 Content-Length，浏览器收到残缺的响应；
  - 404 页受 Range 与条件头影响；
  - 412、416 带着出错前的长缓存头。
  改为错误页总是完整发送，4xx、5xx 一律 `no-store`。
- **站外跳转**：Caddy 补斜杠、去斜杠的默认跳转用原始路径拼 Location，浏览器把 `/\` 当成 `//`、删掉制表符，能拼出跳到站外的地址。GPT 第一轮发现了反斜杠的写法，主持方复现时又发现了制表符的写法。含反斜杠或控制字符的路径一律回 400，按未清理的路径判断。
- **brotli 缺失**：合同原来要求 br，构建机缺 brotli 时部署会回滚。改为 br 与 gzip 都接受，与 4.9 一致。
- **新地址后的杂字符**：上线后 AI 回答里会出现 `/zh-hans/desktop/。` 这类地址，与旧地址同样清理。
- **部署脚本**：
  - 构建工具、站点规则与合同冻结到同一个提交；
  - 部署锁；遗留锁不自动接管，因为第二轮指出两个进程同时接管时都会取得锁；
  - 切换前记下原版本，失败时明确切回它；激活报告失败时先查实际版本；
  - 首次切换要求 `master` 已合进 `rebuild`；
  - ssh 有超时与保活，公网版本核对不吞掉失败。
- **构建检查**：固定图片按清单核对原字节；AASA 必须是合法的 JSON；源文件带来的 `.br`、`.gz` 一律报错（检查在压缩之前运行）。
- **合同**：删掉占位页机制；页面用例核对本页的 canonical；JAR 改用 HEAD；表写错在加载时以 2 退出；连续请求失败时提前停止。
- **其余**：`/ru` 用俄文 404；错误页不做规范化跳转。

**不采纳或改为别的做法**：

- **切换与重载之间不到一秒的空窗**：接受，理由见 5.3。
- **合同核对 JAR 的哈希**：不做。`writer-jars-sync` 按 sha256 校验之后才把 JAR 放进镜像。
- **服务器端的部署事务**：不改 writer-release。部署都从这台 Mac 发起，本机的锁就够了。迁移期间 `master` 的旧脚本不取锁，用「首次切换到 master 快进完成之前不发桌面版」的操作前提代替（第九节 C）。
- **设想中的边角**：都不加代码，包括 `.well-known/` 下的点文件、`.html` 写法后面带杂字符、新地址的杂字符先判断目标是否存在、整轮的总期限、`desktop2.json` 的形状校验、争锁时的提示措辞。
- **第三轮 GPT 复审**：不再发。第二轮的须改都是删代码或补操作前提，由主持方复审，并用本机测试台与假 ssh 的场景验证。
