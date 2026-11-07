# 出口分流

官网服务器出口分流的专项正本：把桌面版 JAR 与旧图片的下载尽量交给 Cloudflare（R2 的 kuromi 存储桶，公开域名 kuromi.drakeet.cn），本站（writer.drakeet.com）只做兜底。起因与 Drakeet 的决定见 [rebuild.md](rebuild.md) 第九节 H 与第十一节「出口带宽被 JAR 下载占满」。各节是设计合同，实施中有变化直接改对应小节；评审记录放在文末。

## 当前游标

- 2026-11-07：方案定稿，尚未开工。8.0 的只读取证已完成，印证了 2.2 的重复下载；第一、二轮复审已按处置修订（见文末评审记录）；第十一节各项都已定。iMac 那套的部署另写不依赖 IDEA 的脚本（rebase-server 仓库），先接管现有的 IDEA 部署，开工时用它部署本方案的代码。
- 进度（2026-11-07 夜）：
  - 8.3 的 S1、S2 完成：R2 上的旧图片副本已上传并核对通过。
  - 第 1 步完成：rebase-server 的 R1～R5（f2550f39，合进 master 为 e3b3af28）与桌面版的 D4、D5（a9c9d742，本地提交、未推送）；GPT（Sol）复审，须改已闭合。
  - iMac 改为脚本部署：rebase-server 的 `deploy_imac.sh`（7e078ce7），launchd 常驻，详见那边的 `docs/imac_deploy.md`；第 1 步的代码已用它部署到 iMac。
  - api.drakeet.com：2026-11-08 早上 Drakeet 运行 `install.sh` 部署，脚本验收通过；部署前的版本备份在 `/opt/tomcat/rebase_2026_11_08_before_egress`。主持方从外部核对：旧版设备先拿到 Cloudflare、带 `urls` 与 `size`，同一设备 25 分钟内再请求仍是 Cloudflare；`multi_source=true`、macOS aarch64、已是最新版的请求都按 3.2 回复；两个下载地址都回 200、大小一致；iMac 仍回 `code` 0。
  - 第 2 步完成：桌面版的新下载器 D1～D3（93db345e，本地提交、未推送），D6 已用 Cloudflare 核对；GPT（Sol）复审，须改已闭合。
  - 第 3 步完成：Android 的 A1、A2（e39399911，本地提交、未推送），A3 在 API 30 模拟器上核对；GPT（Sol）复审，须改已闭合。
  - 剩下：桌面版与 Android 各自发版（第九节第 3、4 步）；发版后按 8.5 看统计、按 8.3 的 S3 更新现役文档。

## 一、目标与边界

- **目标**：发版后的高峰里，本站出口中 JAR 的占比明显下降，网页加载随之改善。基线是 2026-11-07 约 6 小时的实测：出口共约 3959 MB，JAR 占 83%，`/images/` 占 16%，网页占 0.5%。
- **本站始终兜底**：本站在境内、全世界都能访问。任何一处新逻辑失效时，行为都退回「从本站取」，不能出现哪里都下载不到的情况。
- **不做**：加带宽；把网页迁出本站；迁移已存进用户设置的图片地址；改变本站 `/images/` 与 `/ocat/jars/` 的现有行为。

## 二、现状（读代码的结论）

### 2.1 rebase-server 的 `raw/latest_desktop_jar_version`

- `RawJsonResource.latestDesktopJarVersion` 先记录设备（`updateDesktopDeviceRecord`，写 Mongo 的 `desktopDevices`），再调用生成的 `JarVersions.get(changelog, os, osArch, cloudflare = githubAvailable == true)`。
- `JarVersions.get` 里是 `cloudflare || currentTime % 2 == 1L`：GitHub 不可达的设备按请求时刻毫秒数的奇偶，约一半拿到 `kuromi.drakeet.cn`，一半拿到 `writer.drakeet.com/ocat/jars`（`aliOrCloudflare`）。`arrayOf(x).random()` 只有一个元素，不起作用。
- `kuromiHitMap` 只记录、不参与决定。它是普通的 `mutableMapOf`，被并发请求同时修改，不是线程安全的；`githubCount++` 也一样。
- 序列化：Application 同时注册了 Gson（`LOWER_CASE_WITH_UNDERSCORES` 命名策略，`@SerializedName` 优先）与 Jackson（按属性名，`NON_NULL`）。新字段取单个英文单词并加 `@SerializedName`，两者输出才一致；值为 null 时两者都不输出。
- `RawJsonResource` 在所有部署上都注册（不在 `isMainHost` 的条件里）；状态放在进程内存，Mongo 连的是本机。
- 区分部署已有现成的办法：`LocalHosts.isMainHost()` 比较本机主机名与 `MAIN_HOST`（`api.drakeet.com`），Application 据此只在非主机上注册 OCAT 的资源。

### 2.2 桌面版的检查更新与下载

- **检查时机**（`Wwwwwww`、`GlobalInterval`）：启动时只检查一次，请求 `https://api2.drakeet.com/rebase/raw/latest_desktop_jar_version`（`Retrofits.api2`），之后每 30 分钟再请求它一次；每 5 分钟请求 `https://api2.drakeet.cn/raw/latest_desktop_jar_version`（`Retrofits.api3`）。顶栏出现「新版本」提示后，定时检查停止（只在发起定时检查之前看提示，已经发出的检查照常进行）。
- **现在这两个端点与节奏从 2.5.3（2025-06-08）起**。按各版本的 git 标签核对，启动时那次检查一直发往 `api2`，定时检查分六段：

  | 版本 | 定时检查 |
  |---|---|
  | 2.1.9.4（2024-10-01，JAR 自动更新的第一个标签）～2.2.3 | 没有 |
  | 2.2.5.win（2024-10-15）、2.2.6 起 | `api2` 每 1 小时 |
  | 2.2.25（2024-11-08）起 | `api2` 每 30 分钟 |
  | 2.2.39（2024-12-02）～2.2.54.2 | 只有 `api3` 每 8 分钟，`api3` 指向 `https://api.drakeet.cn/`（m4，第三套部署）；两种检查共用一个计数器、每 8 分钟清零，`api2` 的 30 分钟检查永远到不了 |
  | 2.2.56（2024-12-19）～2.5.2 | `api2` 每 30 分钟，`api3` 每 5 分钟，`api3` 仍指向 `api.drakeet.cn` |
  | 2.5.3（2025-06-08）起 | `api2` 每 30 分钟，`api3` 每 5 分钟，`api3` 改指 `api2.drakeet.cn`（提交 f17a7482） |

  所以各版在同一次运行里发往 `api2` 的请求，要么只有启动时一次，要么至少隔 30 分钟。
- **`api2.drakeet.cn` 是另一套部署**：2026-11-07 在 Cloudflare 控制台核对，它经名为「iMac」的 Cloudflare Tunnel 接到 Drakeet 的 iMac（主机名 `iMac.local`，Intel 芯片），不是 m4；m4 的隧道「MacMini」接的是 `api.drakeet.cn` 与 `m4.drakeet.cn`。rebase-server 的 `docs/incremental_sync_switch.md` 推断它是 OCAT 那套部署（JDK 17，`deploy_tomcat.sh`）。它有自己编进去的 JarVersions 与自己的内存状态，而桌面版运行期间的检查多数发往它（5 分钟对 30 分钟）。
- **下载**（`UpdateDelegate.checkJarUpdate`、`downloadFile`）：
  - 只用 `url`，没有备用来源；`lanzou` 地址先解析。
  - OkHttp 默认超时（连接、读取各 10 秒，没有整次时限）；不看状态码，404 页面也写进文件，靠之后的 sha256 不符才发现。
  - 装着 BODY 级别的 `HttpLoggingInterceptor`，它先把整个正文读进内存：每次下载在堆里占一份 JAR（约 42 MB），也无法续传。
  - 没有防重入：下载期间的每次检查都会再开一份完整下载。多份下载共用同一个目标文件（每次开始先删它），可能互相删除或覆盖，至少会重复改写 cfg。慢的下载每 5 分钟多一份，旧规则下其中约一半指向镜像。
  - sha256 一致后改写 cfg（`updateCfgFile`：在 `$APPDIR` 行之前保留至多两行 Kuromi 的 classpath），删除不在 cfg 里的旧 JAR，显示顶栏提示。sha256 不符、Kuromi 目录或 cfg 不可写时转而调用 `checkDesktopUpdate`（可能弹出下载安装包的对话框）；抛出异常时（例如连不上）只有非 `cnMode` 才这样做。
- **GitHub 可达性**（`GitHubConnectivityChecker`）：启动时异步探测五个端点，全部成功才为真。启动时那次检查用的是上次保存的值；从没测过时按时区与语言猜（不是上海时区、且不是简体中文时为真）。
- **设备标识**：`X-Device-Id` 是本机生成的 16 个随机小写字母，每个请求都带；`X-App-Version-Code` 是当前运行的 JAR 的版本号。

### 2.3 JarVersions 的生成

- 模板是桌面版仓库根目录的 `JarVersions.kt`（包名是服务端的）。构建各平台 JAR 时，`generateMetadata` 写出一段构造参数（code、name、changelog、buildTime、sha256，以及写死 `https://kuromi.drakeet.cn/` 的 url）；`updateJarVersions` 把三段填进模板，并把 `.jar"` 替换成 `.jar".aliOrCloudflare(cloudflare)`。
- `buildAllJars.sh` 在上传 R2、同步并核对镜像之后，把生成的文件复制到 rebase-server 并提交（不推送），部署由 Drakeet 执行。
- `updateJarVersions` 的逻辑写在任务的配置块里，在 Gradle 配置阶段执行；`build/jars/metadata` 里若残留旧版本的文件，取哪一份取决于 `listFiles` 的顺序。`buildAllJars.sh` 构建前先 `cleanJars` 清空 `build/jars`，按这个流程不会残留；单独运行任务时没有这层保护。

### 2.4 R2 上的清理逻辑（结论：不会碰到 `writer/`）

- 删除对象的代码共三处：
  - 桌面版 `buildAllJars.sh` 第 3 步，经 `scripts/release-common.sh` 的 `r2_delete`：键必须整串匹配 `^PureWriter2-[0-9.]+-(Windows-x64|macOS-x64|macOS-aarch64)\.jar$`；
  - 桌面版 `release.sh` 的 `prune_installers`，同样经 `r2_delete`：键必须整串匹配 `^PureWriter2-[0-9]+(\.[0-9]+)+-(Windows-x64\.exe|macOS-x64\.dmg|macOS-aarch64\.dmg)$`；
  - OCAT 仓库（`/Users/drakeet/Documents/Flutter/OCAT`）的 `fastlane/upload_android_apk_to_r2.sh`：上传新 APK 之后，列出键以 `ocat` 开头、以 `.apk` 结尾的对象，删掉除新键之外最旧的一个。它直接调用 aws，不经 `r2_delete`。
- `writer/images/…` 不以 `PureWriter2-` 或 `ocat` 开头，三处都不可能选中它。桌面版的 `r2_put` 与 OCAT 的上传都以 `basename` 作键，也不会写进 `writer/`。
- 在本机的 rebase-server、桌面版、Android、官网、iOS 仓库与 `~/Documents/Flutter` 下搜过 `kuromi` 与删除对象的调用，没有别的代码清理这个存储桶。服务器上的 `writer-jars-sync` 只经公开地址读取。
- Cloudflare 控制台上的对象生命周期规则已核对（第十一节第 8 条）：只有默认的「7 天后中止未完成的分段上传」，不删除对象。
- 仍加一道防护（6.1），以后改桌面版的正则时也不会误删。

### 2.5 Android 的旧图片

- **用到 `https://writer.drakeet.com/images/` 的地方**：
  - 稿纸：`PaperSelectorActivity` 的候选、`Settings` 的默认稿纸、`PaperDelegate` 的缩略图、`WriterActivity.setCoverBackground` 的背景、`WriterTheme` 按地址取颜色；
  - 首次启动预取：`DeferredInit.warmUpPapers`，每个安装只做一次，4 张稿纸加 6 张 Pro 图；
  - Pro 介绍页：各语言 `ProIntroductionMarkdown` 里的图片，经 Markwon 的 `GlideImagesPlugin`；
  - 「关于」页的 `icon512.png`。
- **加载方式**：全部经 Glide 4.16，网络层是 `okhttp4-integration`（`GlidesModule` 是 AppGlideModule）。缓存键由模型（这串站内地址，`GlideUrl` 的 cache key）与签名、尺寸等参数决定。`WriterActivity` 用 `DiskCacheStrategy.ALL`，其余用默认策略（远程图片缓存原始数据）。
- **离线与弱网**：缓存过的图片直接从磁盘取；没缓存过的加载失败，稿纸背景留空，「关于」页显示占位图标。弱网时受 OkHttp 默认超时约束。
- 稿纸地址存进用户设置并随同步传到其他设备；iOS 与桌面版的代码里没有用到这些地址。

## 三、服务端合同（rebase-server）

### 3.1 JSON

旧字段与含义不变；新增两个可选字段，值为 null 时不输出：

| 字段 | 类型 | 说明 |
|---|---|---|
| `url` | 字符串 | 旧版桌面版唯一读取的下载地址，取值按 3.2 逐台设备决定 |
| `urls` | 字符串数组 | 新增。同一个文件的全部来源，按优先顺序排列：Cloudflare 在前，本站镜像在后。只放 `https://` 地址 |
| `size` | 整数 | 新增。文件的字节数，供新版校验长度与续传 |

例（一台旧版设备此刻被分到镜像）：

```json
{
  "code": 5020000,
  "name": "5.2.0",
  "sha256": "…",
  "changelog": "…",
  "buildTime": 1794000000000,
  "url": "https://writer.drakeet.com/ocat/jars/PureWriter2-5.2.0-Windows-x64.jar",
  "urls": [
    "https://kuromi.drakeet.cn/PureWriter2-5.2.0-Windows-x64.jar",
    "https://writer.drakeet.com/ocat/jars/PureWriter2-5.2.0-Windows-x64.jar"
  ],
  "size": 44040192
}
```

- 新版桌面版请求时加查询参数 `multi_source=true`，表示它自己选来源。服务端对它不做 3.2 的逐台判断，`url` 固定给 Cloudflare，也不记录它。应急时可以让服务端不理会这个参数（3.5、第九节）。
- **向后兼容**：旧版桌面版用 Gson 解析，忽略不认识的字段。新版桌面版遇到没有 `urls` 的服务端（尚未部署的那一套），只用 `url`，即现有行为。
- **两个特殊的 `code`**：
  - -1（`emptyRedirect`，不认识的平台）：含义不变。旧版收到 -1 会转而检查安装包更新、可能弹出对话框，所以不能拿它表示「暂时不更新」。
  - 0：本方案新增的「暂不下发」，其余字段为空串。旧版只在 `code` 大于当前版本时下载、只在 -1 时转去检查安装包，所以 0 对 2024-09 引入 JAR 自动更新以来的各版都是无操作（`UpdateDelegate` 的这两处判断从第一版起就是这个形状）；新版同样什么都不做。用在 3.2 的冷却期与 3.3。

### 3.2 旧版桌面版：按设备回落

下发更新的只有 `api.drakeet.com`（3.3）。每台设备（`X-Device-Id`）、每个版本一条记录：所处阶段（Cloudflare 或镜像）、第一次下发的时刻、最近一次给镜像的时刻。每次请求按顺序判断：

| # | 情形 | 回复 | 记录 |
|---|---|---|---|
| 1 | 设备已是最新版本（`X-App-Version-Code` ≥ 最新） | 照常（客户端不会下载） | 删除；计入「已更新」 |
| 2 | 新版客户端（`multi_source=true`）、没有设备标识、或报告 GitHub 可达 | Cloudflare | 不记录 |
| 3 | 没有记录，或记录的是别的版本 | Cloudflare | 新建，进入 Cloudflare 阶段，记下此刻 |
| 4 | Cloudflare 阶段，距第一次下发不到 25 分钟 | Cloudflare | 不变 |
| 5 | Cloudflare 阶段，满 25 分钟 | 镜像 | 转入镜像阶段，记下此刻 |
| 6 | 镜像阶段，距上次给镜像不到 25 分钟 | 镜像 | 记下此刻 |
| 7 | 镜像阶段，距上次给镜像 25～120 分钟 | 暂不下发（`code` 0） | 不变 |
| 8 | 镜像阶段，距上次给镜像满 120 分钟 | 镜像 | 记下此刻 |

数值与理由：

- **不到 25 分钟的请求只可能来自重启**：各版在同一次运行里发往 `api.drakeet.com` 的请求，要么只有启动时一次，要么至少隔 30 分钟（2.2）。所以第 4、6 行的请求一定是 App 重启后的启动检查，上一份下载已随进程结束，再给同一个来源不会造成重叠。这个推断依赖 3.3：`api2.drakeet.cn` 每 5 分钟、`api.drakeet.cn` 每 5 或 8 分钟一次，它们若也下发，这两行就要改成「暂不下发」。
- **25 分钟没下成才给镜像**：
  - 阈值要小于 30 分钟，连不上 Cloudflare 的设备才能在本次运行的第一次定时检查就拿到镜像。不取正好 30 分钟：30 分钟的计时与启动检查几乎同时开始，启动检查的网络耗时可能让两次请求到达服务端的间隔略少于 30 分钟。
  - 能连 Cloudflare 的设备，只要速度不低于约 28 KB/s（42 MB ÷ 25 分钟），就会在阈值之前下完；下完后顶栏出现提示，定时检查随之停止。更慢的设备会在 30 分钟那次检查拿到镜像，与还没结束的那份同时下载；两份共用同一个目标文件（2.2），这是已发布版本的缺陷，只能尽量减少重叠。
  - App 在 25 分钟内反复重启，每次仍拿到 Cloudflare、重新开始下载，不会被切到镜像。
- **冷却按来源分别定**：
  - 给 Cloudflare 之后不设冷却：Cloudflare 阶段里不到 25 分钟的请求只可能是重启，没有重叠可防；满 25 分钟就转镜像。
  - 给镜像之后冷却 120 分钟：8.0 实测镜像下完一份的耗时中位约 30 分钟、p90 约 104 分钟（当时重复下载很多，镜像更挤），120 分钟内的定时检查回「暂不下发」，九成以上的镜像下载能在下一份开始之前结束。一台反复失败的设备（例如下完了却改写不了 cfg）最多每 2 小时从镜像拉一份，约占镜像的 2.5%。代价：镜像那份因退出 App 而中断、又隔 25 分钟以上才重新打开的设备，要等满 120 分钟才再拿到镜像。上线后按统计（8.5）调整。
- **GitHub 可达的设备只给 Cloudflare**：按 Drakeet 的决定不变。它们多在境外，而镜像在上海、只有 2 Mbps；这类设备若连不上 Cloudflare，由新版桌面版自己换来源。
- **去掉抛硬币**：`currentTime % 2`、`kuromiHitMap` 与 `aliOrCloudflare` 一并删除。

### 3.3 只由 `api.drakeet.com` 下发更新（Drakeet 已定）

- **做法**：按主机名区分，只有 `api.drakeet.com`（`LocalHosts.isMainHost()`，2.1）给旧版下发；其余部署，即 iMac 上的 `api2.drakeet.cn` 与 m4 上的 `api.drakeet.cn`，对新旧版的请求一律回「暂不下发」（`code` 0）。不新增配置；3.2 的逐台记录与新版的多来源报价都只在 `api.drakeet.com` 一处，发版只需部署它。
- **好处**：
  - 不会两边各下发一份：几套各管各的内存时，一台设备可能从两边各拿到一次 Cloudflare 与一次镜像，几份同时下载；
  - 3.2 第 4、6 行「不到 25 分钟只可能是重启」的推断才成立，重启后的设备不必白等；
  - 决定旧版下载哪个版本的只有一套 JarVersions，不会因为几套部署的先后，让旧设备先去下一个较旧的版本；
  - iMac 那套只需部署一次这份代码，此后旧版的分发不依赖它随发版部署，也不受它关机影响（桌面版代码里已注明 cn 服务器可能会关机）；
  - m4 那套不必为本方案专门部署：它按自己的节奏部署时自然带上这份代码，不论何时部署，都不会与 `api.drakeet.com` 各发一份。
- **代价**：
  - 旧版发现新版本最多晚 30 分钟：启动时那次检查照常，只是少了每 5 分钟的那条路径；多数用户打开 App 时就会拿到；
  - 只连得上 `api2.drakeet.cn`、连不上 `api.drakeet.com` 的旧版设备收不到更新。`api.drakeet.com` 同时承担账号与授权，连不上它的设备本来就有更大的问题，这个代价可以接受；
  - 2.2.39～2.5.2 的定时检查有一部分发往 m4（2.2）。m4 部署这份代码之前，这部分检查照旧按 m4 上现有的规则（毫秒奇偶）拿地址；部署之后一律「暂不下发」。其中 2.2.39～2.2.54.2 运行中只检查 m4，届时只在启动时从 `api.drakeet.com` 拿到报价，连不上 Cloudflare 时要等下一次启动（满 25 分钟后）才拿到镜像。这批很早的版本降级为只在启动时更新，可以接受；
  - iMac 那套仍要部署一次，否则它继续按毫秒奇偶给 2.5.3 起的旧版一半镜像。
- **新版也只由 `api.drakeet.com` 回答**（Drakeet 定）：新版同样在启动时与每 30 分钟从 `api.drakeet.com` 发现新版本，每 5 分钟发往 iMac 的那条检查只拿到「暂不下发」。这样 iMac 不必随发版部署；新版晚一些发现新版本，与旧版相同。
- **不采用时**：各套都按 3.2 下发，第 4、6 行改为「暂不下发」（这时 25 分钟内的请求可能来自每 5 分钟的检查，下载还在进行），重启后的设备要等满 25 分钟；一台设备仍可能从两边各拿到一份；iMac 与 m4 都要随发版部署。

### 3.4 状态放在内存

- 用 `ConcurrentHashMap`，键是设备标识，值记版本号、阶段与两个时刻；每次请求用 `compute` 原子地读改写。
- **规模**：只记「还停在旧版本、且报告 GitHub 不可达」的旧版设备，更新后即删除；部署新版本时进程重启，自然清空。另设上限 10 万条，超过时整表清空，代价只是这些设备从第 3 行重新开始。
- **重启之后**：所有设备从第 3 行重新开始，已在镜像阶段的设备要再过 25 分钟才回到镜像。部署通常发生在发版时，那时版本号本来就变了，影响很小。所以不放 Mongo：每次请求多一次读写，换来的只是重启后少等 25 分钟。

### 3.5 代码结构

- `type/LatestJarVersion`：加 `urls: List<String>? = null` 与 `size: Long? = null`，各带 `@SerializedName`；加「暂不下发」的构造（`code` 0，其余为空串）。
- 新类型 `DesktopJarBuild(sha256, size, buildTime, cloudflareUrl, mirrorUrl)`。
- 生成的 `JarVersions.kt` 只放数据（第五节）：`VERSION_NAME`、`VERSION_CODE`（`latestDesktopVersion` 仍在用）与三个平台的 `DesktopJarBuild`。现在写在生成的 `get` 里的平台选择，移到手写代码。
- 新增手写的 `DesktopJarOffers`：按 os／arch 选平台，按 3.2、3.3 选回复，拼出 `urls` 与 `size`。「本机是否下发旧版」（取自 `LocalHosts.isMainHost()`）与时钟由外部传入，便于单元测试。`RawJsonResource.latestDesktopJarVersion` 只保留设备记录与 2.2.7 的旧特例，其余交给它。
- **应急开关**：一个常量 `MULTI_SOURCE_ENABLED`（默认 true）。改为 false 时，服务端不理会 `multi_source`、不输出 `urls`，新版就和旧版一样经 3.2、3.3 拿 `url`，需要镜像的设备照样拿到镜像。改它只需重新部署 `api.drakeet.com`：其余部署对新版本来就只回「暂不下发」（3.3）。
- `DebugResource` 里 `kuromiHitMap` 那一行改为本进程的统计：首次下发 Cloudflare 的设备数、给镜像的次数、回「暂不下发」的次数、给过镜像后更新的设备数、没给过镜像就更新的设备数。验收看 `api.drakeet.com` 上的这一行（8.5）。
- `api.drakeet.com` 运行 JDK 8，只用 JDK 8 的 API。

## 四、桌面版：自己选来源

### 4.1 来源列表

- 有 `urls`：去掉不是 `https://` 的与重复的，至多取 4 个，按顺序作为来源列表；全部不合格时退回 `url`。
- 没有 `urls`（尚未部署的服务端，或应急开关关闭）：只有 `url` 一个来源，`lanzou` 地址照旧先解析。仍用新的下载器，得到续传、防重入与流式写盘，只是不换来源。
- `code` 为 0、-1 或不大于当前版本时，照现有判断处理，不下载。
- `api2` 与 `api3` 的请求都带 `multi_source=true`。

### 4.2 下载状态机

现有的检查时机（启动、每 5 分钟、每 30 分钟）各算一轮。一轮里按顺序把每个来源各试一次，所有来源共用同一个临时文件：

1. **准备**：
   - 临时文件按版本与 sha256 区分：`Kuromi/<版本号>-<sha256 前 8 位>.jar.part`。不同版本的临时文件各自保留，互不影响。
   - **不回头**：在同一把锁内取两者中较高的版本作为下限：已校验并落位的最高版本（第 5 步记下，持久保存），以及 24 小时内有过写入的临时文件的最高版本。报价低于下限就不处理：不下载，也不改写 cfg。这样两套部署短暂不一致时不丢较新版本的进度，较新版本落位之后、旧报价才被处理时也不会改写成较旧的版本。不依赖顶栏提示或定时检查是否已停：提示只拦得住还没发起的检查，cfg 改写失败时也不会出现。超过 24 小时没有写入的临时文件视为放弃、删除，服务端撤回某个版本时不会卡住。
   - 报价等于已落位的版本、且 `<版本名>.jar` 的 sha256 一致：跳过下载，直接接第 5 步之后的现有流程（例如上次改写 cfg 失败，这次重做）。
   - 本版本的临时文件比 `size` 长：清空。
2. **连接**：已有 n 个字节时带 `Range: bytes=n-`。下列任一情况算这个来源失败，换下一个：
   - 从发出请求到收到响应头超过 15 秒（每条路由的连接超时 5 秒；整段时限用定时取消实现，OkHttp 的 `callTimeout` 管整次请求，不适合长下载）；
   - 状态码不是 200 或 206；
   - 206 的 `Content-Range` 起点不是 n，或总长与 `size` 不符；给出的 `Content-Length` 与应收字节数不符。
   - 特例：带了 Range 却收到 200（服务器不认 Range），清空临时文件，从这份正文从头写。416 且 n 等于 `size`，直接进入第 4 步；否则清空临时文件，算失败。
3. **接收**：边收边追加写入临时文件。
   - 20 秒收不到一个字节：失败，换下一个来源，已收的字节保留。
   - **太慢**（只在后面还有来源时判断）：收到响应头满 30 秒起，每 5 秒看一次最近 30 秒的平均速度，低于 20 KiB/s 就主动断开、换下一个来源，已收的字节保留。最后一个来源不做这项判断，慢也要下完。
4. **核对**：长度达到 `size`（没有 `size` 时以服务器给的总长为准）后算 sha256。不符时删除临时文件，然后：
   - 这份文件全部来自当前来源：本轮不再用它，下一个来源从零下载；
   - 混有前面来源的字节：当前来源从零重下一次；
   - 每个来源每轮至多从零下载一次，从零下载的文件单独核对；没有可用的来源时本轮失败。
   - 这样即使 Cloudflare 一直给出错误的内容，或它留下的片段与镜像拼起来不对，镜像也能在同一轮里完整下载一次并单独核对。
5. **落位**：临时文件改名为 `Kuromi/<版本名>.jar`（同一目录内原子改名，失败时退为覆盖），记下这个版本号作为已落位的版本，删除版本不高于它的临时文件，之后接现有流程：改写 cfg、删除旧 JAR、显示顶栏提示。cfg 里第一条 Kuromi 的 classpath 已经是这个 JAR 时不再改写，避免现有的重复两行。

- **本轮全部失败**：保留临时文件，下一轮从断点继续，仍从第一个来源开始（Cloudflare 的状况随时段变化，不记住上次的选择）。失败后是否调用 `checkDesktopUpdate` 照现有的分支（2.2）。
- **防重入**：整轮（含落位与改写 cfg）用一把 `Mutex`，`tryLock` 失败就直接返回。向服务端发请求不在锁内：api2 与 api3 的检查会落在同一拍，若从请求起就持锁，只回 `code` 0 的 api3 可能抢到锁、让真正下发的 api2 落空；下限在锁内取，锁外拿到的旧报价照样被拦下。`checkDesktopUpdate`（可能弹出模态对话框）也在锁外调用。
- **实现时的几处细化**（第 2 步，主持方裁决、GPT 复审认可）：
  - 临时文件名里的「版本号」是 versionCode，例如 `5010000-8859faa8.jar.part`；
  - 已落位的最高版本记在 `Kuromi/PlacedVersion`（文本，内容是 versionCode），放在目录里而不是偏好里，重装换掉目录时随之消失；写入失败只记日志，同时 `JarUpdater` 在内存里记住本进程落位过的最高版本。重启之后运行的就是新落位的 JAR，调用方只把比正在运行的版本新的报价交给 `JarUpdater`，保护自然延续；
  - 本报价自己的临时文件超过 24 小时也不删：服务端仍在报这个版本，它不是放弃了的，留着续传；
  - 报价不低于下限、`<版本名>.jar` 已在且 sha256 一致时复用，不限于「等于已落位版本」，记录已落位版本失败过时也不必重下；
  - 请求一律带 `Accept-Encoding: identity`：OkHttp 只在不带 Range 时自动要 gzip，否则续传的偏移与 `Content-Length` 对不上；206 没有到文件末尾也算失败；200 的 `Content-Length` 先核对再截断临时文件。
- 下载用单独的 OkHttpClient：不带 BODY 级别的日志，也不带业务拦截器（下载的都是公开文件，不需要设备请求头与签名）。

### 4.3 数值与依据

- **镜像的实际速度**：出口整形到 1900 kbit/s，约 237 KB/s，CAKE 按主机公平分配。11-07 的高峰里同时有十几台主机在下载，每台约 20 KB/s，一份 JAR（约 42 MB，三个平台一版约 127 MB）要 35 分钟左右；闲时一台独占约 3 分钟。
- **最低速度 20 KiB/s**：大约是镜像在高峰里分给每台主机的份额。Cloudflare 比这还慢时，换到镜像不会更差，而且续传不浪费已收的字节；比这快就留在 Cloudflare，把镜像留给确实需要它的设备。代价：闲时镜像可能比 25 KB/s 的 Cloudflare 快，这类设备仍留在 Cloudflare，可以接受。
- **观察 30 秒、每 5 秒看一次**：国内到 Cloudflare 的线路丢包时，重传退避会造成几秒的停顿，30 秒的平均能把它平滑掉；相对 35 分钟的下载，多等 30 秒的代价很小。
- **每条路由连接 5 秒、响应头 15 秒**：正常时跨太平洋的握手在 1 秒内完成；地址被丢弃时 SYN 没有回应，单条路由 5 秒就放弃，15 秒内还能再试一两条（kuromi.drakeet.cn 解析出多个地址）。
- **20 秒没有数据算断开**：容得下两三轮重传退避；更长的停顿说明连接已经不通。
- **不回头的 24 小时**（只用于临时文件）：两套部署先后部署的间隔通常在几小时之内；24 小时足以覆盖，又不会让撤回版本的设备久等。已落位的版本不设时限：它已经写进 cfg（或下次重做），重启后就运行它，回到较旧的版本没有意义。

### 4.4 测试方式

- 下载器单独成类（例如 `JarDownloader`），OkHttpClient、时钟与上述阈值都由构造参数传入。单元测试用 MockWebServer（桌面版已有这项测试依赖），阈值按测试需要调小，不把具体数值写成断言。
- 隔离运行（`DevIsolation`）不检查更新，所以端到端靠下载器的单元测试，加一次对真实来源的手动核对（8.2 的 D6）。

## 五、生成 JarVersions 的脚本

- `generateMetadata`：只写文件本身的事实，即文件名、sha256、字节数、buildTime；不再写地址。
- `updateJarVersions`：
  - 逻辑移到 `doLast`，执行时才读 metadata；
  - 两个基址由 Gradle 属性传入：`-PjarCloudflareBase`、`-PjarMirrorBase`，缺一个就失败；地址等于基址加 `/` 加文件名；
  - 写文件之前核对：三个平台各恰好一份 metadata，文件名都含本次的 `versionName`，sha256 是 64 位十六进制，字节数大于 0，模板里不剩占位符。不符就失败。
- 模板 `JarVersions.kt` 改为只放数据：

  ```kotlin
  object JarVersions {
    const val VERSION_NAME = "<VERSION_NAME>"
    const val VERSION_CODE = <VERSION_CODE>
    val MAC_AARCH64 = DesktopJarBuild(<macOS-aarch64>)
    val MAC_X64 = DesktopJarBuild(<macOS-x86_64>)
    val WINDOWS_X64 = DesktopJarBuild(<Windows>)
  }
  ```

- `buildAllJars.sh` 的 `commit_jar_versions` 调用时传入 `R2_PUBLIC_BASE_URL`（release-common.sh）与 `MIRROR_BASE_URL`（buildAllJars.sh）。两个基址在桌面版这边各只有一处，服务端代码里不再写死任何基址。
- **两个仓库必须同时换**：模板换了而服务端没换（或反过来），rebase-server 编译失败，Drakeet 打包时就能发现，不会悄悄带错上线。两边的改动同一天落地，赶在下一次桌面发版之前。

## 六、R2

### 6.1 清理防护

- 结论见 2.4：现有三处清理都不会碰到 `writer/`。
- 防护：`release-common.sh` 的 `r2_delete` 遇到含 `/` 的键直接报错退出，注释写明桶里 `writer/` 下是官网旧图片的副本、Android 新版本在用。本产品的 JAR 与安装包都在桶的根目录，这道检查不影响现有清理。
- 这道防护只管桌面版的两个脚本。OCAT 的脚本不经 `r2_delete`，靠它自己的前缀与后缀筛选（`ocat` 开头、`.apk` 结尾）；改那份脚本时同样不能放宽到桶里的其他对象。

### 6.2 上传旧图片

- **对象键**：`writer/` 加 `ops/images.sha256` 里的路径，例如 `images/papers/0.jpg` 对应 `writer/images/papers/0.jpg`；共 43 个文件、7,214,775 字节（约 7 MB）。这份清单是唯一正本：只传清单里的文件，传之前先核对本地 `static/` 下的字节与清单一致。
- **上传方式**：`aws s3api put-object`，profile `cloudflare-r2`（不用 `s3 cp`，理由同 release-common.sh：它默认附带的校验算法与 R2 不兼容）。
  - `--content-type`：`.jpg` 为 image/jpeg，`.png` 为 image/png，`.webp` 为 image/webp，`.svg` 为 image/svg+xml，与本站 Caddy 给的一致；
  - `--cache-control "public, max-age=604800"`：与本站 `/images/` 相同，一周。字节永不改变，本可以给一年加 immutable；取一周是为了万一传错，Cloudflare 边缘最多一周就自动更正，不必依赖清缓存。
- 首次上传前先列 `--prefix writer/`，应当为空；不为空先停下核对。
- 做成官网仓库里可以重跑的脚本，例如 `scripts/r2-images.sh upload|verify`，在 Drakeet 的 Mac 上运行（R2 凭据在那里）。

### 6.3 核对

`verify` 做三件事，全部通过才算完成：

1. 列出 `--prefix writer/` 的键，与清单逐一对应，不多不少；
2. 每个文件经公开地址 `https://kuromi.drakeet.cn/writer/<路径>` 取回（不跟随跳转，不带 Accept-Encoding），sha256 与清单一致；
3. 同一响应的状态码是 200，Content-Type 与 Cache-Control 是 6.2 的值。

- 字节不符时看对象本身，需要时清除该地址的缓存后重传。drakeet.cn 区域没有开图片优化（第十一节第 8 条），Cloudflare 不会改动图片字节。
- 可选：官网的外部监控（`.github/workflows/monitor.yml`）加一条，按清单核对一张稿纸的 R2 副本。

## 七、Android：先试 Cloudflare，失败回到本站

### 7.1 放在哪一层：给 Glide 的 `OkHttpUrlLoader` 换一个自己的 `Call.Factory`

- 在 `GlidesModule.registerComponents` 里用 `registry.replace(GlideUrl::class.java, InputStream::class.java, OkHttpUrlLoader.Factory(callFactory))` 换上自己的 `Call.Factory`（Glide 4.16 的 `OkHttpUrlLoader.Factory` 本来就接受它）。现有的生成类 `GeneratedAppGlideModuleImpl` 先注册各 LibraryGlideModule、再调用 AppGlideModule（第一轮复审已核对），所以会覆盖 okhttp4-integration 注册的那个。Glide 的 ModelLoader 与 DataFetcher 都照旧：`OkHttpStreamFetcher` 调 `newCall(request)` 后 `enqueue`，取消时调这个 Call 的 `cancel()`。
- 这个 `Call.Factory` 只接管主机为 `writer.drakeet.com`、路径以 `/images/` 开头、没有查询串、且路径在内置清单（7.2）里的 GET；其余请求直接交给一个与 OkHttp 默认一致的客户端，文章里用户自己的网络图片行为不变。
- **接管的请求返回一个包装 Call，里面依次发两个子 Call**：
  - 先发 R2 的子 Call，它有自己的整次时限（7.2），覆盖 DNS、各条路由的连接、TLS、响应头与正文；
  - R2 失败才发本站的子 Call（原请求、默认超时），把它的结果交给 Glide；
  - 包装 Call 记着当前的子 Call：Glide 取消时，把取消传给它；已取消就不再发本站的子 Call。
- **不选的做法**：
  - 改写调用处的地址：缓存键会变成 R2 的地址，已缓存的图片要重新下载；回退要在稿纸、预取、Markdown、「关于」页各写一遍。
  - 在应用拦截器里对同一个 Call 两次 `chain.proceed`：`withConnectTimeout`、`withReadTimeout` 管不到响应头返回之前的 DNS 与多条路由的连接重试，整次时限做不出来；定时取消外层 Call 又会让随后本站那次也失败（第二轮复审须改 1）。
  - 另建一个 R2 客户端、却不把 Glide 的取消传过去：离开页面后仍下载到超时（第一轮复审须改 2）。
- **缓存键与来源无关**：模型（站内地址）与签名、尺寸等参数都不变，缓存键就不变。旧版本缓存下来的图片在新版本里继续命中，不重新下载；设置里存的地址原样不动，不做迁移。

### 7.2 超时、校验与失败的判定

- **超时**：R2 的子 Call 用 `callTimeout(10 秒)`、每条路由连接超时 4 秒、读取超时 5 秒；正文在包装 Call 里读完（上限 2 MiB），读完 OkHttp 的整次计时才结束，所以 10 秒管住从 DNS 到正文读完的全过程。本站的子 Call 用默认超时。
- **校验**：Android 内置这批固定图片的 sha256，整份抄入官网 `ops/images.sha256` 的 43 条；字节永不改变，所以一次抄入、不需要同步机制。R2 的正文读完后先算 sha256，与清单一致才交给 Glide。
- 下列任一情况算 Cloudflare 失败，改为请求原地址（本站）：
  - 任何 IOException（DNS、连接、TLS、读取、超过整次时限）；
  - 状态码不是 200；
  - 正文超过上限，或 sha256 与清单不符。
- **取消**：包装 Call 已被 Glide 取消时，把取消传给当前的子 Call，向 Glide 报失败，不发本站的子 Call，也不更新暂停状态。
- **整次 10 秒的依据**：Android 用到的图片最大约 275 KB（`papers/5.jpg`），10 秒内下完要求不低于约 30 KB/s；更慢时改从本站取，与现在的体验相同。正文必须在包装 Call 里读完并校验：若留给 Glide 去读，读到一半超时就来不及回退，字节不对也已经进了缓存。
- **本进程内暂停 Cloudflare 30 分钟**：Cloudflare 因连接或服务端错误失败（IOException 或 5xx）、紧接着本站成功时，记下时刻，之后 30 分钟内这类请求直接走本站。这样在连不上 Cloudflare 的地区，Pro 页同时加载的六七张图只付一次等待。404、sha256 不符、本站也失败（多半是离线）与取消都不触发暂停。
- **离线**：Cloudflare 立刻失败（DNS 解析不了），本站也失败，与现在相同；缓存过的图片不经网络。
- **坏图不会进缓存**：R2 的字节不对就不交给 Glide，所以 R2 上的对象即使出错，也不会以站内地址的键污染磁盘缓存。本站的响应照旧不校验，与现在相同。
- **实现时的细化**（第 3 步，主持方裁决、GPT 复审认可）：R2 请求新建、不沿用原请求的头，只有 Host、Connection、Accept-Encoding 与 OkHttp 的 User-Agent；不跟随跳转，按「状态码不是 200」回本站、不暂停；「本站成功」指收到 2xx 响应头；DNS 解析单独限时（系统解析是同步的，`callTimeout` 唤不醒它），整次仍不超过约 10 秒；取消在交付响应与写入暂停之前都在同一把锁里检查。接管的请求在 OkHttp dispatcher 的线程里同步发子 Call，不受每主机并发数限制，接管范围只有 43 个固定路径，可以接受。本站那次的读取超时不变，与现在相同。

### 7.3 调试入口

- 仅调试构建：可以把 R2 基址改为不可路由的地址（模拟连不上）或不存在的路径（模拟 404），用于设备核对。正式构建没有这个入口。

## 八、任务清单与验收

### 8.0 开工前的只读取证（官网服务器访问日志，需经 Drakeet 同意再连服务器）

- 按 IP 汇总 11-05 至今 `/ocat/jars/` 的字节数、请求次数与相邻请求的间隔，看有没有同一台设备每 5 或 30 分钟重复整包下载（印证 2.2 的重复下载），以及带 Range 的请求占比（旧版应为 0）。
- 用结果核对 3.2 的 25 分钟与给镜像之后的冷却是否合适。

**结果（2026-11-07，访问日志 10:20～18:36，只统计 UA 为 okhttp 的 `/ocat/jars/PureWriter2-*` 请求，按 IP 与文件分组）**：

- 245 次下载，下完整个文件的只有 73 次；字节共 4932 MB，其中 2171 MB（44%）来自同一 IP 对同一文件的重复下载。
- 104 次重复下载里，81 次在上一份还没结束时就开始了，即同时有两份以上在下载。相邻两次开始的间隔：不到 1 分钟 35 次（代码里启动时只检查一次，这些多半是同一出口 IP 后的多台设备，或短时间内重启 App），4～6 分钟 31 次（每 5 分钟的检查），6～25 分钟 27 次，25 分钟以上 10 次。
- 下完一份的耗时：中位约 30 分钟，p90 约 104 分钟，最快约 3 分钟。
- 带 Range 的请求为 0（另有 3 次来自 curl），与「旧版不能续传」一致。下载请求不带 `X-Device-Id`，日志里只能按 IP 区分，同一出口 IP 后的多台设备会被算作一台，以上重复的比例是上限。
- 结论：重复下载是本站出口被占满的主要原因之一。3.2、3.3 让旧版的重复下载大多不再发生（只由一处下发，给镜像之后冷却），新版由 4.2 的防重入与续传解决。25 分钟的首次回落阈值有依据；给镜像之后的冷却按镜像下完一份的耗时定为 120 分钟（p90 约 104 分钟），现有数据只能说明它能减少重叠，上线后按统计调整。

### 8.1 rebase-server

| # | 任务 | 验收 |
|---|---|---|
| R1 | `LatestJarVersion` 加 `urls`、`size` 与「暂不下发」的构造；新增 `DesktopJarBuild` | 单元测试：同一个对象经 `Globals.newGson()` 与 `localObjectMapper` 序列化，键名都是 `urls`、`size`；值为 null 时两者都不输出；「暂不下发」的 `code` 是 0 |
| R2 | 现有的 `JarVersions.kt`（5.1.0）手工改成新格式，各平台字节数经 R2 公开地址的 HEAD 取得 | 测试：三个平台都在；两个地址分别以两个基址开头、以同一个文件名结尾；文件名含 `VERSION_NAME` |
| R3 | `DesktopJarOffers` 按 3.2、3.3 实现，替换抛硬币与 `kuromiHitMap`；加 `multi_source` 查询参数与应急开关 | 单元测试覆盖 3.2 每一行：首次给 Cloudflare；25 分钟内再来仍给 Cloudflare；满 25 分钟给镜像；给镜像后 25 分钟内再来仍给镜像；25～120 分钟回 `code` 0；满 120 分钟再给镜像；更新后删除记录；换了版本重新开始；GitHub 可达与 `multi_source` 始终给 Cloudflare；超过上限清空。另测：不下发的部署对新旧版、对认不出的平台都回 `code` 0；应急开关关闭时不理会 `multi_source`、不输出 `urls` |
| R4 | `DebugResource` 的统计行 | — |
| R5 | `RawJsonResourceModelTest` 照常通过 | 按 rebase-server 的 AGENTS.md，在单独的检出里用 JDK 8 与 `pom.xml` 只跑相关测试类 |

部署后（Drakeet 执行）：用 curl 带一个测试用的设备标识（`X-Device-Id`）、较低的 `X-App-Version-Code`，以及 `X-OS`（例如 `Windows 11`）与 `X-Arch`，否则会落到「认不出的平台」回 -1；不带 `X-OS-Version`，这样不会写进 `desktopDevices`。

- `api.drakeet.com`：第一次回 Cloudflare；25 分钟后回镜像；紧接着再请求仍回镜像；再过 30 分钟回 `code` 0；每次都有 `urls` 与 `size`（`code` 0 除外）。
- `api2.drakeet.cn`：带不带 `multi_source` 都回 `code` 0。
- `api.drakeet.cn`（m4，等它按自己的节奏部署之后）：同样一律回 `code` 0。

### 8.2 桌面版

| # | 任务 | 验收 |
|---|---|---|
| D1 | `LatestJarVersion` 加 `urls: List<String>?`、`size: Long?`（Gson 绕过构造函数，必须是可空类型，列表元素也要防 null）；接口加 `multi_source` | — |
| D2 | `JarDownloader` 按 4.2 实现 | MockWebServer 用例：第一个来源拒绝连接，换第二个并下完；第一个来源限速，按阈值切换，第二个来源收到的 Range 起点正好是已收字节数；第二个来源不认 Range、回 200，从头写并下完；最后一个来源中途断开，保留临时文件，下一轮从断点续传；第一个来源内容错误、镜像正确，同一轮里镜像从零下载并通过核对，最终更新成功；混有两个来源的字节且核对不符，当前来源从零重下；只有 `url` 时单来源；416 且临时文件已完整，直接核对；`Content-Range` 起点不符算失败；较新版本的临时文件 24 小时内有写入时不下载较旧的报价，超过 24 小时则删除它、照常下载；落位后删除版本不高于它的临时文件 |
| D3 | `UpdateDelegate`：防重入、不回头的下限（含已落位的版本）、临时文件与改名、复用已下好的 JAR、cfg 首条已是该 JAR 时不改写、去掉 BODY 日志 | 用例：两次并发的检查只有一次在下载；较新版本落位后，旧报价才被处理，既不重新下载、也不改写 cfg；等于已落位版本的报价不重新下载，只重做改写 cfg |
| D4 | 生成脚本按第五节修改，`buildAllJars.sh` 传入两个基址 | 在临时目录里用假的 metadata 跑一次 `updateJarVersions`，输出与预期一致；缺属性、缺平台、版本不符、残留占位符都失败 |
| D5 | `r2_delete` 拒绝带 `/` 的键 | 传入一个带 `/` 的键，报错退出，没有调用 aws |
| D6 | 对真实来源的手动核对（做一次） | Range 已在第一轮复审中实测：以 OkHttp 的 UA 请求 Windows 5.1.0 JAR 的前 100 字节，两个来源都回 206、`Content-Range: bytes 0-99/42554438`、没有跳转。2026-11-07 已做：下载器以不可路由的地址为第一个来源、Cloudflare 为第二个来源（不用镜像整包下载：镜像出口只有 2 Mbps），5 秒连接超时后换到 Cloudflare，下完 42,554,438 字节，sha256 与 JarVersions 一致；对 Cloudflare 续传回 206、`Content-Range` 正确；镜像只用 Range 小请求核对 206 与 416 |

### 8.3 官网仓库

| # | 任务 | 验收 |
|---|---|---|
| S1 | `scripts/r2-images.sh`（upload、verify） | 已完成（2026-11-07）：只有上传与核对，没有删除操作；清单本地字节不符、前缀不为空都拒绝上传 |
| S2 | 上传并核对（经 Drakeet 同意后运行，或由他运行） | 已完成（2026-11-07，上海时间 20:22 上传）：43 个键不多不少、共 7,214,775 字节；经公开地址逐个 sha256 一致，200、类型与缓存头正确；用法见 operations.md 5.3 |
| S3 | 上线后更新现役文档：rebuild.md 第三节 `/ocat/jars/` 一行与 5.6（不再是「约一半」）、第七节的衔接表、第九节 H 的执行记录并链接本文；operations.md 5.2 | — |
| S4 | 可选：外部监控加一条 R2 副本的核对 | 监控跑通 |

### 8.4 Android

| # | 任务 | 验收 |
|---|---|---|
| A1 | `Call.Factory` 与包装 Call（两个子 Call、内置 sha256 清单、整次时限、取消传递与暂停逻辑）；在 `GlidesModule` 换上 | MockWebServer 用例：R2 回 200 且字节正确，本站没有收到请求；R2 回 200 但字节不符，转本站，不暂停；R2 回 404，转本站，不暂停；R2 拒绝连接，转本站并暂停，下一次直接走本站；两边都失败，报错且不暂停；R2 迟迟不回响应头、在响应头返回之前就超过十秒，转本站；R2 正文读到一半超过十秒，转本站；R2 进行中 Glide 取消，R2 的子 Call 随之取消，本站没有收到请求，不暂停；清单里没有的路径不请求 R2；别的主机、别的路径、带查询串的请求直接交给默认客户端 |
| A2 | 调试构建的 R2 基址入口 | — |
| A3 | 设备核对 | ① 装旧版本，加载过稿纸与 Pro 页，升级到新版本后开飞行模式，图片照常显示（缓存键没变）；② 正常网络下清除应用数据，稿纸与 Pro 页的请求发往 kuromi.drakeet.cn（抓包，或看本站访问日志里没有这台设备的 `/images/` 请求）；③ 用调试入口模拟连不上与 404，图片在不超过约十秒内从本站显示出来（只有一个不可路由地址时约 4 秒） |

### 8.5 总体验收

- 下一次桌面发版后的高峰（上海时间 21～22 点）：按访问日志统计本站出口，JAR 的占比比 83% 明显下降，同一 IP 对同一文件的重复下载明显减少；HTML 请求的耗时（日志里的 `duration`）随之下降。
- `api.drakeet.com` 的统计（3.5）：给过镜像的设备占需要更新的设备的比例，就是「连不上 Cloudflare」的实际规模；回「暂不下发」的次数与镜像下载的耗时分布，用来调整 120 分钟的冷却，也作为第十节是否分批推送的依据。
- `/images/` 的下降要等 Android 新版本普及，不作为这次发版的验收项。

## 九、上线顺序与回退

1. rebase-server 与桌面版的生成脚本同一天落地（第五节）；R1～R5 通过后，由 Drakeet 部署 `api.drakeet.com` 与 iMac 上那套。部署即生效：旧版桌面版按 3.2、3.3 回落。m4 上那套不必专门部署，按它自己的节奏部署时自然带上（3.3）。
2. 官网仓库 S1、S2：上传并核对旧图片。随时可做，须在 Android 发版之前。
3. 带新下载器的桌面版照常发版（release.sh）；这个版本本身经第 1 步的规则分发给旧版。
4. 带新 `Call.Factory` 的 Android 版本发版。

回退：

- **rebase-server**：回退提交并重新部署。
- **新版桌面版的多来源出了问题**：把应急开关 `MULTI_SOURCE_ENABLED` 改为 false，重新部署 `api.drakeet.com`。服务端不理会 `multi_source`、不输出 `urls`，新版就像旧版一样按 3.2、3.3 拿 `url`，需要镜像的设备照样拿到镜像。新版仍在用新的下载器（单来源）；下载器本身的故障这样救不回来，要靠修复版，或请用户从官网下载安装包重装。
- **Android**：R2 失败本来就回到本站，不需要远程开关；R2 上的字节不对会被 sha256 挡下，同样回到本站，不会进缓存。R2 副本有误时重传，即可恢复分流。
- R2 上的 `writer/` 对象不影响任何旧版本与站外引用：本站的 `/images/` 原样提供。

## 十、分批推送（只评估，不实现）

- **可行，只改 rebase-server**：按设备标识的哈希取 0～99，小于当前比例的设备给新版本，其余设备回「暂不下发」（3.1 的 `code` 0）。比例随时间升高，例如 1 小时 10%、6 小时 30%、24 小时 100%。
- **要处理的**：
  - 计时起点要扛得住重启：写进生成文件的常量（发版时刻），或部署时设定；不能用进程的启动时刻；
  - 采用 3.3 时只有 `api.drakeet.com` 给旧版下发，分批只在这一处判断；不采用时两套部署要用同一个哈希函数与同一个起点，结果才一致；
  - 紧急修复要能一键全量，例如生成文件里的开关。
- **是否值得**：Cloudflare 的出口不收费，分批对它没有意义；分批只为保护镜像，而按设备回落之后，镜像只承担连不上 Cloudflare 的那部分设备。更对症的是给镜像设名额，例如每 10 分钟至多给出 N 次镜像地址，超出的这次给 Cloudflare、等下一次检查。建议先看第一次发版后的统计（8.5）再决定。

## 十一、待定事项（都已定）

1. ~~iMac 与 m4 两处的部署方式~~（Drakeet 2026-11-07 答复）：
   - iMac：`api2.drakeet.cn` 经 Cloudflare Tunnel 接到它（2.2），原先由 Drakeet 在 IDEA 里点本地 Tomcat 的运行配置部署（JDK 8，与 `api.drakeet.com` 同一套构建）。现在改由 rebase-server 仓库里不依赖 IDEA 的部署脚本接管，本方案开工时用它部署一次；按第 2 条，此后不必随发版部署。
   - m4：`api.drakeet.cn` 接到它，2.2.39～2.5.2 的桌面版定时检查它（2.2）。不必为本方案专门部署，按它自己的节奏部署时自然带上这份代码（3.3）。
2. ~~只由 `api.drakeet.com` 下发~~（Drakeet 2026-11-07 同意，3.3）：iMac、m4 等其余部署对新旧版一律回 `code` 0，发版只部署 `api.drakeet.com`。
3. ~~3.2 的两个数~~（主持方裁决：采用）：在 Cloudflare 上 25 分钟没下成就给镜像；给镜像之后冷却 120 分钟，期间回「暂不下发」。依据是 8.0 的实测与 2.2 的检查间隔，上线后按 8.5 的统计调整。
4. ~~GitHub 可达的旧版设备只给 Cloudflare、不随失败回落~~（Drakeet 已定，保留）。
5. ~~新版桌面版的「太慢」门槛~~（主持方裁决：采用）：最近 30 秒的平均速度低于 20 KiB/s，约等于镜像高峰时分给每台主机的份额（4.3）。
6. ~~R2 旧图片的缓存头~~（主持方裁决：一周）：与本站相同；万一传错，Cloudflare 边缘最多一周自动更正，不依赖清缓存。
7. ~~R2 的上传由谁运行~~（主持方运行）：Drakeet 已同意把旧图片传到 kuromi 存储桶的 `writer/images/`；脚本在他的 Mac 上运行，上传后按 6.3 核对。
8. ~~Cloudflare 控制台上仓库里看不到的两处~~（2026-11-07 已在控制台核对）：kuromi 存储桶的对象生命周期规则只有默认的「7 天后中止未完成的分段上传」，不删除对象；drakeet.cn 区域是免费套餐，Polish 需要 Pro，没有开启，R2 上的图片字节不会被改动。
9. ~~分批推送~~（主持方裁决：先不做）：先看第一次发版后的统计（8.5），见第十节。

## 十二、风险与已知问题

读代码时发现的，部分不在本方案范围内：

- 旧版桌面版下载期间每次检查都会再开一份完整下载，多份共用同一个目标文件，且整份 JAR 先读进内存（2.2）。已发布的版本改不了，3.2、3.3 的一处下发与冷却只能减少重叠；新版由 4.2 的防重入与流式写盘解决。
- 3.2 第 4、6 行依赖旧版的检查节奏（同一次运行里发往 `api.drakeet.com` 的请求只有启动时一次，或至少隔 30 分钟）。已发布的各版都满足（2.2）；新版不经过这张表，以后改节奏也不受影响。
- 早期旧版的边界（3.3）：2.2.39～2.5.2 的部分定时检查发往 m4，在 m4 部署这份代码之前仍按毫秒奇偶拿地址；部署之后，其中 2.2.39～2.2.54.2 只在启动时拿到报价，连不上 Cloudflare 时要等下一次启动才拿到镜像。
- `kuromiHitMap` 与 `githubCount` 的并发修改不安全（2.1），随 R3 去掉，或改为线程安全的计数。
- `updateJarVersions` 在配置阶段执行，单独运行且 metadata 有残留时取哪份不确定（2.3），由 D4 解决。
- GitHub 可达性在启动时那次检查里用的是上次的结果（2.2）。3.2 的第 2 行依赖它，刚换了网络的设备可能被判错一次，影响只是多给一次 Cloudflare 或晚一次回落。
- 两套部署的 JarVersions 不一致时（一边已部署新版、另一边还没有）：采用 3.3 时只影响新版，新版按 4.2 保留较新版本的进度、不回头下载；不采用时，比两边都旧的旧版设备可能先被引导去下载较旧的那一版。
- 隐私：Android 新版本加载旧图片时会访问 kuromi.drakeet.cn（Cloudflare），请求不带原请求的头、也不带设备或账号信息，只有 OkHttp 的默认请求头（有单元测试锁住）。记入 rebuild.md 第十一节的隐私系列，届时一并写进政策。桌面版用到的两个下载地址与现在相同。
- 过渡期：用旧脚本构建的 JAR（metadata 是旧的 `.json` 格式）不能再用新的生成脚本 `buildAllJars.sh --sync-only` 续做，会报缺平台。5.1.0 已经发布，下一次发版整套用新脚本，影响不大。

## 评审记录

### 2026-11-07 第一轮（GPT，Astra：4 项须改、2 项可选，按主持方处置全部采纳）

- **现状核实**：启动时只检查一次，8.0 对「不到 1 分钟」的解释改正（多半是同一出口 IP 后的多台设备，或短时间内重启）；OCAT 的 fastlane 脚本也清理 kuromi 桶（只删 `ocat` 开头、`.apk` 结尾的对象，不经 `r2_delete`），改写 2.4 与 6.1；Glide 的注册顺序已核对；缓存键不变的理由改为模型与签名不变（7.1）；2.3 的「没有出过问题」改为可由流程证明的说法。
- **须改 1**：sha256 不符后，本轮让后面的来源从零下载、单独核对（4.2 第 4 步），补「第一来源内容错误、镜像正确，最终更新成功」的用例。
- **须改 2**：Android 的 R2 尝试改在同一个 Call 里经 `chain.proceed` 发出，随 Glide 取消，超时用 `chain.withConnectTimeout`、`withReadTimeout` 加读正文时的截止时间；取消时不回退、不暂停（7.1、7.2）。第二轮发现这个超时管不到响应头之前，已改为自定义 `Call.Factory`，见下一节。
- **须改 3**：应急回退改为服务端不理会 `multi_source`、不输出 `urls`，两套部署同时生效，新版按 3.2 拿 `url`；下载器本身的故障靠修复版或安装包（3.5、第九节）。
- **须改 4**：Android 内置 43 条 sha256，R2 的正文先校验再交给 Glide，不符改走本站，清单外的路径直接走本站；回退一节删去「删除对象就能恢复」（7.2、第九节）。
- **可选 1**：给镜像之后冷却 120 分钟、期间回 `code` 0，冷却按来源分别定（3.2）。主持方提出的「只由 `api.drakeet.com` 给旧版下发」经评估写进 3.3，列入第十一节第 2 条。
- **可选 2**：临时文件按版本与 sha256 保留，成功落位后清理；24 小时内有进展的较新版本不因另一套部署的旧报价回头下载（4.2 第 1、5 步）。
- 复审另外实测：本地 43 张图片与清单一致，共 7,214,775 字节；两个来源对 Range 都回 206（8.2 的 D6）。

### 2026-11-07 第二轮（GPT，Astra：2 项须改、1 项可选，按主持方处置全部采纳）

- 上一轮的须改 1、3、4 确认落实；须改 2 与可选 2 各有缺口，即本轮的两项须改。
- **须改 1**：同一个 Call 里两次 `chain.proceed` 的截止时间管不到响应头返回之前。改为给 Glide 的 `OkHttpUrlLoader` 换自己的 `Call.Factory`：R2 是独立的子 Call，带 `callTimeout(10 秒)`，覆盖 DNS、各路由连接、TLS、响应头与正文；Glide 的取消传给当前子 Call，取消后不回退、不暂停；本站那次照常。7.1 的「不选的做法」改写，A1 补「响应头返回之前就超过十秒」的用例。
- **须改 2**：「不回头」只看 `.part`，较新版本落位后失去保护。改为在同一把锁内取「已校验并落位的最高版本」与「24 小时内有写入的临时文件的最高版本」中较高的为下限，不再依赖顶栏提示或定时检查是否已停（4.2 第 1、5 步），补「较新版本落位后，旧报价才被处理」的用例。实施细节：低于下限的报价不处理；等于已落位版本的报价不重新下载，只重做改写 cfg（上次 cfg 改写失败时要能补上），所以没有写成「不高于下限一律不处理」；cfg 首条已是该 JAR 时不改写。
- **可选 1**：查清各版本的端点与节奏（2.2）：现在的两个端点与节奏从 2.5.3（2025-06-08，提交 f17a7482）起；2.2.39～2.5.2 的 `api3` 指向 m4 上的 `api.drakeet.cn`，其中 2.2.39～2.2.54.2 共用计数器、每 8 分钟清零，运行中只检查 m4。3.3 改为按主机名只由 `api.drakeet.com` 给旧版下发，iMac 与 m4 一律「暂不下发」，代价写进 3.3 与第十二节；第十一节第 1 条改为确认 iMac 与 m4 两处的部署方式。
