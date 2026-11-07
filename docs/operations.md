# 官网服务器运维手册

writer.drakeet.com 所在服务器的现役事实，以及部署与运维的日常操作。服务器的设计与取舍见重建方案 `docs/rebuild.md` 第五、六节；本文只写「现在是什么样、要做某件事该怎么做」。服务器上的配置都来自本仓库的 `ops/`，改配置先改仓库、提交并推送，再按第 6 节同步过去。

## 1. 概况

| 项目 | 现值 |
|---|---|
| 实例 | 阿里云 ECS `i-uf678ldzwkkp9h7uavnt`，华东 2（上海）可用区 L，`ecs.s6-c1m1.small`（1 vCPU、1 GiB），40 GiB 高效云盘，包年包月，到期 2029-03-11 |
| 网络 | 公网 IP `106.14.149.103`（实例自带的固定公网 IP，不是 EIP，更换系统盘不会变）；私网 `172.29.122.120`；固定带宽 2 Mbps（出方向） |
| 系统 | Ubuntu 26.04 LTS（2026-11-07 更换系统盘装入，镜像 `ubuntu_26_04_x64_20G_alibase_20261023`） |
| Web 服务器 | Caddy 2（官方 Cloudsmith 源，`apt-mark hold`，升级只走第 5 节的受控升级） |
| 主机名 | `writer.drakeet.com`（正式站）、`writer2.drakeet.com`（预发站）、`drakeet.com` 与 `www.drakeet.com`（旧静态页，去留见 rebuild.md 5.7） |
| 证书 | Caddy 自动签发与续期：Let's Encrypt 为主，ZeroSSL 兜底；ACME 账户邮箱 writer@drakeet.com |

**主机密钥指纹**（2026-11-07 经云助手在服务器上读取，与外部扫描一致）：

```
ED25519  SHA256:69pwr5H5YCKs5TrDeKmMXOa71p5cM2FjeExSzQbnOiU
ECDSA    SHA256:GKMqfKExJPTfUFX3naSv6x3qvUDRmlJemfHzHlbrgWQ
RSA      SHA256:KxfFWXqFCTYMNwg3BEZAVWXHYkXDpJiYN47D7qbvR2g
```

以后连接时若提示主机密钥变了，先停下核对，不要直接接受。

## 2. 账户与登录

- **drakeet** 是唯一能登录的账户，只认公钥（本机的 `id_rsa` 与 `id_ed25519`），在 `adm`（读日志）、`sudo`、`caddy`（经管理接口重载 Caddy）三个组里，拥有 `/srv/writer.drakeet.com`。
- **root** 锁定，SSH 不允许 root 登录（`/etc/ssh/sshd_config.d/00-writer.conf`：只认公钥、`AllowUsers drakeet`、关闭 X11、代理与 TCP 转发）。
- **sudo**：重建期间 drakeet 有免密 sudo（`/etc/sudoers.d/90-drakeet-nopasswd`）。重建收尾时收回，步骤见第 9 节；此后 sudo 要输入 drakeet 的口令。

## 3. 防火墙

ufw 与阿里云安全组保持同一份白名单。改动任何一处，同时改另一处和这张表。

| 方向 | 协议与端口 | 来源 | 用途 |
|---|---|---|---|
| 入 | TCP 22 | 任意 | SSH（只认公钥） |
| 入 | TCP 80 | 任意 | HTTP 跳转 HTTPS；ACME 验证 |
| 入 | TCP 443 | 任意 | HTTPS |
| 入 | UDP 443 | 任意 | HTTP/3 |
| 入 | 其余 | — | 拒绝（安全组优先级 100 的「拒绝全部」；ufw 默认拒绝入站） |
| 出 | 全部 | — | 允许 |

个人代理原先用的 8621 端口已在 2026-11-07 从安全组删除；以后重新部署代理时，两处都要加回来。

## 4. 目录

```
/srv/writer.drakeet.com/releases/<UTC 时间>-<提交>/public/   站点文件（网站根目录）
/srv/writer.drakeet.com/releases/<UTC 时间>-<提交>/caddy/    这一版的站点规则 site.caddy
/srv/writer.drakeet.com/current → releases/…                当前版本
/srv/writer.drakeet.com/previous                            上一版的版本号（回滚用）
/srv/writer.drakeet.com/staging/                            预发站，结构相同
/srv/writer.drakeet.com/jars/                               桌面版 JAR 国内镜像，对外是 /ocat/jars/
/srv/writer.drakeet.com/jars-incoming/                      JAR 下载中的临时文件，不对外
/srv/legacy/drakeet.com/                                    drakeet.com 的旧静态页
/etc/caddy/Caddyfile                                        全局配置（来自 ops/caddy/Caddyfile）
/var/log/caddy/                                             Caddy 运行日志与访问日志
/usr/local/bin/writer-*                                     服务器端脚本（来自 ops/bin/）
/root/writer-provision/                                     初始化脚本的输入：ops/ 副本、authorized_keys、drakeet.com 页面
```

## 5. 日常操作

### 5.1 部署与回滚

在官网仓库主目录（`/Users/drakeet/GitHub/writer.drakeet.com`，`master`）里：

```bash
scripts/deploy.sh              # 部署已提交的 HEAD 到正式站（只接受 master）；切换后跑 URL 合同，不通过自动切回
scripts/deploy.sh --staging    # 部署到预发站 writer2.drakeet.com（任何分支都可以）
scripts/deploy.sh --rollback   # 切回上一版；再执行一次就回到刚才的版本（加 --staging 对预发站）
```

- 部署只发布已提交的内容：开头取一次提交号，产物、构建工具与检查配置、站点规则与 URL 合同都取自这个提交，工作区里的草稿和部署期间别人新做的提交都不影响。
- 每次部署是服务器上的一个新版本目录（`public/`、`caddy/site.caddy`、`checks/`）；内容没变的文件与上一版共用 inode，实际上传的只有改动。保留最近 5 份。
- 切换之后在服务器上跑这一版附带的 URL 合同（`checks/contract.py --site <主机名>`，连本机 443、按主机名带 SNI，不经公网），正式站另从本机核对线上 `desktop2.json` 的版本；任何一项不通过都自动切回切换前的版本。合同表是 `ops/contract.tsv`，格式写在表头。
- 站点规则 `caddy/site.caddy` 随版本一起发布、一起回滚；Caddy 拒绝新规则时会自动切回原版本。改了规则或合同，提交之前先在本机运行 `scripts/test-caddy.sh`：它按服务器的目录结构搭测试台，用与服务器同版本的 Caddy 跑整张合同。
- 同一时间只有一次部署：deploy.sh 在 git 公共目录里加锁（`.git/writer-deploy.lock`），含 `--rollback`。部署进程被强杀或机器死机时锁会遗留，再部署会拒绝并给出移除命令，确认没有部署在进行后照做即可。
- 出口被 JAR 下载占满时上传很慢：整站上传（预发站第一次部署）用过约 10 分钟，增量部署通常一两分钟。
- 查看服务器上的版本：`ssh drakeet@writer.drakeet.com writer-release status prod`。
- 桌面版 `release.sh` 的 deploy 步骤调用的也是这个脚本。

### 5.2 桌面版 JAR 镜像

- 发版时 `buildAllJars.sh` 在 JAR 上传 R2 之后执行 `ssh drakeet@writer.drakeet.com writer-jars-sync <版本> <文件名>=<sha256>…`：服务器从 R2 下载、核对 sha256 后放进 `jars/`，再由本机核对镜像的大小。
- 已存在且哈希一致的文件会跳过，重跑无害。按版本号保留最近 7 个版本。
- 镜像同步失败时，修好后在桌面版仓库运行 `./buildAllJars.sh --sync-only`，不必重新构建。
- 实测速度：2026-11-07 上午（上海时间），每个版本三个包（约 127 MB）约 2 分钟。晚高峰尚未实测。

### 5.3 日志

- 访问日志 `/var/log/caddy/access.log`：JSON，含主机名与访客 IP；保留 183 天（《网络安全法》要求不少于六个月），到期自动删除。drakeet 在 `adm` 组里，不用 sudo 就能读。
- Caddy 自身的运行日志（证书、配置加载）在 `/var/log/caddy/caddy.log`，不在 journald 里。
- 例子：

```bash
# 最近 404 最多的地址
ssh drakeet@writer.drakeet.com "jq -r 'select(.status==404) | .request.uri' /var/log/caddy/access.log | sort | uniq -c | sort -rn | head -20"
# 证书相关的报错
ssh drakeet@writer.drakeet.com "jq -c 'select(.level==\"error\")' /var/log/caddy/caddy.log | tail -20"
```

## 6. 修改服务器配置

全局 Caddyfile、服务器端脚本、SSH、防火墙、系统参数都由 `ops/provision.sh` 安装。它分四步，每一步都可以重复执行：

| 步骤 | 内容 |
|---|---|
| `users` | drakeet 账户与组、公钥、重建期间的免密 sudo（drakeet 有口令之后不再安装） |
| `web` | Caddy 与 systemd 片段、目录与占位版本、服务器端脚本、全局 Caddyfile、ufw |
| `ssh --drakeet-login-verified` | SSH 配置片段（校验不过会撤回） |
| `harden` | swap、时区、系统更新、自动更新、journald 上限、BBR、Caddy 受控升级的定时器、出口整形 |

流程：

1. 在本仓库的 `master` 上改 `ops/`，提交并推送（`master` 上未推送的提交会挡住桌面发版的预检）。
2. 把 `ops/` 同步到服务器（root 不能 SSH 登录，经 drakeet 与 sudo）：

```bash
COPYFILE_DISABLE=1 tar --no-mac-metadata --no-xattrs -C /Users/drakeet/GitHub/writer.drakeet.com -cf - ops | ssh drakeet@writer.drakeet.com 'sudo rm -rf /root/writer-provision/ops && sudo tar -C /root/writer-provision -xf - --no-same-owner'
```

3. 运行对应的步骤，例如改了 Caddyfile 或 `ops/bin/` 里的脚本：

```bash
ssh drakeet@writer.drakeet.com 'sudo /root/writer-provision/ops/provision.sh web'
```

`web` 会以 caddy 身份校验配置再重启 Caddy；校验不过就停下，不会重启到坏配置上。

只改了 `ops/bin/` 里的某个脚本时，不必重跑 `web`（它会重启 Caddy，线上短暂中断）：同步 `ops/` 之后，单独安装那个脚本即可，命令与 `web` 里的相同：

```bash
ssh drakeet@writer.drakeet.com 'sudo install -m 0755 -o root -g root /root/writer-provision/ops/bin/<脚本> /usr/local/bin/<脚本>'
```

## 7. 自动维护

| 项目 | 机制 | 核对方法 |
|---|---|---|
| 系统安全更新 | unattended-upgrades；需要重启时 04:30（上海时间）自动重启 | `journalctl -u unattended-upgrades`，`ls /var/run/reboot-required` |
| Caddy 升级 | `writer-caddy-upgrade.timer`，每周一 05:00 左右：先用新版本以 caddy 身份校验现行配置，通过才装，装后跑正式站当前版本附带的 URL 合同（当前版本没有附带合同时只查 AASA、首页与一个不存在的路径），失败自动装回原版本 | `journalctl -t writer-caddy-upgrade` |
| 证书续期 | Caddy 内置 | `/var/log/caddy/caddy.log` |
| 出口整形 | `writer-shaping.service`：CAKE 整形到 1900 kbit（略低于 2 Mbps），有人下载 JAR 时网页仍然流畅；带宽改了要同步改 `ops/bin/writer-shaping` 的 RATE | `tc -s qdisc show dev eth0` |
| 拥塞控制 | BBR，默认队列 fq（`/etc/sysctl.d/90-writer.conf`） | `sysctl net.ipv4.tcp_congestion_control` |
| 内存 | 2 GiB swapfile；journald 上限 1 GB | `swapon --show`，`free -m` |
| 时间 | chrony，阿里云内网 NTP | `chronyc sources` |
| Caddy 崩溃 | systemd `Restart=on-failure` | `systemctl status caddy` |
| 外部监控 | GitHub Actions 定时任务（`.github/workflows/monitor.yml`），每 15 分钟从境外检查首页（跟随跳转）、AASA、`desktop2.json`、该版本的三个镜像 JAR（HEAD）、http 跳转与证书剩余天数；两轮都不通过时这次运行失败，GitHub 发邮件 | GitHub 仓库 PureWriter/writer.drakeet.com 的 Actions 页面；`gh run list --workflow=monitor.yml` |

2026-11-07 做过一次重启检验：网站约 35 秒后恢复，上述服务全部自动起来。

外部监控的几点说明：

- 失败通知发给最后修改 cron 那一行的 GitHub 账号（目前是 drakeet），要在 GitHub 的 Settings → Notifications → Actions 里开着「失败时发邮件」。
- 公开仓库 60 天没有提交时，GitHub 会停用定时任务（会先发邮件提醒）；平时桌面发版就会产生提交，若被停用，在 Actions 页面重新启用即可。
- 检查点在境外，GitHub 的调度也常有十几分钟的延迟，所以它只用来发现「挂了」，不用来衡量国内访问速度。
- 首页按访客语言跳转（不带语言头时 302 到 `/zh-hans/`），监控跟随跳转后检查最终是 200 的网页。

## 8. 出了问题

- **网站打不开**：先看 `systemctl status caddy`，再看 `/var/log/caddy/caddy.log`（证书、配置）与 `journalctl -u caddy`（进程启动失败）。刚部署过的话，先 `scripts/deploy.sh --rollback`。
- **SSH 连不上**（救援通道）：阿里云控制台 → 云服务器 ECS → 运维与监控 → 云助手 → 找到实例 → 执行命令。命令以 root 执行，不经过 SSH，可以用来查看或修复 `sshd_config.d`、`authorized_keys`、ufw。drakeet 设了口令之后，也可以用控制台的远程连接（VNC）以 drakeet 登录。
- **Caddy 升级后出问题**：受控升级失败会自动装回原版本；需要手动装回某个版本时：`sudo apt-mark unhold caddy && sudo apt-get install --allow-downgrades caddy=<版本> && sudo apt-mark hold caddy`。
- **重新初始化整台服务器**：更换系统盘后按 rebuild.md 第九节 A 的窗口步骤执行，第 6 节的四步依次运行，然后部署站点、同步 JAR。服务器上没有不可再生的数据。

## 9. 收回重建期间的免密 sudo

重建全部完成后执行。全程保留一个 root 会话，口令验证通过之前不要关掉它。

1. Drakeet 在自己的终端里给 drakeet 设口令（口令只由他本人输入）：

```bash
ssh -t drakeet@writer.drakeet.com sudo passwd drakeet
```

2. 打开会话 A，进入 root shell，保持不关：

```bash
ssh -t drakeet@writer.drakeet.com sudo -i
```

3. 在会话 A 里删除免密文件：`rm /etc/sudoers.d/90-drakeet-nopasswd`。
4. 另开会话 B，验证口令 sudo，输入刚设的口令：

```bash
ssh -t drakeet@writer.drakeet.com 'sudo -k; sudo -v && echo 口令 sudo 正常'
```

5. 看到「口令 sudo 正常」后再关闭会话 A。若验证失败，在会话 A 里检查 `id drakeet` 是否含 `sudo` 组，或把免密文件恢复回去。
