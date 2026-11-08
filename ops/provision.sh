#!/usr/bin/env bash
# 官网服务器初始化（Ubuntu 26.04 LTS，阿里云 ECS）。以 root 运行，每一步都可以重复执行。
#
# 准备：把仓库的 ops/ 目录传到服务器的 /root/writer-provision/ops/，并在 /root/writer-provision/ 放：
#   authorized_keys   drakeet 账户允许登录的公钥（不入库）
#
# 顺序（防止把自己锁在外面，见 docs/rebuild.md 5.3）：
#   provision.sh users      建 drakeet 账户（adm、sudo 组）、公钥、重建期间的免密 sudo
#   —— 另开一个连接确认 ssh -o BatchMode=yes drakeet@writer.drakeet.com true 成功 ——
#   provision.sh web        装 Caddy，建目录与占位版本，装服务器端脚本，启用防火墙（先放行 22）
#   provision.sh ssh --drakeet-login-verified
#                           收紧 SSH：只认公钥、禁止 root、只允许 drakeet
#   provision.sh harden     swap、时区、系统更新、自动更新、日志上限、BBR、Caddy 受控升级的定时器、出口整形
#
# 前两步加上第一次部署就足以恢复网站；harden 放在网站恢复之后做。
set -euo pipefail

readonly OPS="$(cd "$(dirname "$0")" && pwd)"
readonly INPUT="$(dirname "$OPS")"
readonly ADMIN=drakeet
readonly SITE_BASE=/srv/writer.drakeet.com
readonly BOOTSTRAP_ID=00000000T000000Z-bootstrap

log() { echo "== $*"; }
die() { echo "provision: $*" >&2; exit 1; }

require_root() {
	[[ "$(id -u)" -eq 0 ]] || die "需要以 root 运行"
}

require_ubuntu() {
	. /etc/os-release
	[[ "$ID" == ubuntu ]] || die "只为 Ubuntu 编写，当前是 $PRETTY_NAME"
	[[ "$VERSION_ID" == 26.04 ]] || echo "provision: 注意，当前是 $PRETTY_NAME，脚本按 26.04 编写" >&2
}

apt_install() {
	DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "$@"
}

# ---------------------------------------------------------------------------
# users：drakeet 账户、公钥、重建期间的免密 sudo
# ---------------------------------------------------------------------------
cmd_users() {
	local keys="$INPUT/authorized_keys"
	[[ -s "$keys" ]] || die "缺少 $keys（drakeet 允许登录的公钥）"
	if ! id "$ADMIN" >/dev/null 2>&1; then
		log "创建账户 $ADMIN"
		useradd --create-home --shell /bin/bash "$ADMIN"
	fi
	# 口令字段设为 *：不能用口令登录，但账户不算「锁定」，公钥登录不受影响。
	# 收尾时由 Drakeet 本人设口令，再收回免密 sudo（docs/rebuild.md 5.3）。
	if [[ "$(getent shadow "$ADMIN" | cut -d: -f2)" == '!'* ]]; then
		usermod -p '*' "$ADMIN"
	fi
	# sudo 组：/etc/sudoers 里的 %sudo 给口令 sudo。收回免密 sudo 之后，root 只能经它取得（root 不能 SSH 登录）。
	# adm 组：不用 sudo 就能读系统日志与 Caddy 的访问日志。
	usermod -aG adm,sudo "$ADMIN"

	install -d -m 0700 -o "$ADMIN" -g "$ADMIN" "/home/$ADMIN/.ssh"
	install -m 0600 -o "$ADMIN" -g "$ADMIN" "$keys" "/home/$ADMIN/.ssh/authorized_keys"

	# 重建期间的免密 sudo，只在 drakeet 还没有口令时安装：Drakeet 设了口令、收回免密之后，重跑 users 不会再装回来。
	# 文件名与旧服务器相同，收尾时的收回命令不用改。先校验语法再安装，写错也不会弄坏 sudo。
	if [[ "$(getent shadow "$ADMIN" | cut -d: -f2)" == '*' ]]; then
		local tmp
		tmp="$(mktemp)"
		echo "$ADMIN ALL=(ALL) NOPASSWD:ALL" > "$tmp"
		visudo -cf "$tmp" >/dev/null
		install -m 0440 -o root -g root "$tmp" /etc/sudoers.d/90-drakeet-nopasswd
		rm -f -- "$tmp"
	fi

	log "完成。下一步：另开连接确认 ssh -o BatchMode=yes $ADMIN@writer.drakeet.com true 成功，再运行 web"
}

# ---------------------------------------------------------------------------
# web：Caddy、目录、占位版本、服务器端脚本、防火墙
# ---------------------------------------------------------------------------
install_caddy_repo() {
	local keyring=/usr/share/keyrings/caddy-stable-archive-keyring.gpg
	local list=/etc/apt/sources.list.d/caddy-stable.list
	if [[ ! -s "$keyring" ]]; then
		curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key | gpg --dearmor -o "$keyring"
		chmod 0644 "$keyring"
	fi
	if [[ ! -s "$list" ]]; then
		curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt -o "$list"
		chmod 0644 "$list"
	fi
}

# 建一份占位版本，让 Caddyfile 里的导入在第一次部署之前也存在，Caddy 能正常启动。
ensure_bootstrap_release() {
	local dir="$1"
	install -d -m 0755 -o "$ADMIN" -g "$ADMIN" "$dir" "$dir/releases"
	if [[ ! -e "$dir/current" ]]; then
		local rel="$dir/releases/$BOOTSTRAP_ID"
		install -d -m 0755 -o "$ADMIN" -g "$ADMIN" "$rel" "$rel/public" "$rel/caddy"
		install -m 0644 -o "$ADMIN" -g "$ADMIN" "$OPS/bootstrap/public/index.html" "$rel/public/index.html"
		install -m 0644 -o "$ADMIN" -g "$ADMIN" "$OPS/bootstrap/caddy/site.caddy" "$rel/caddy/site.caddy"
		ln -sfn "releases/$BOOTSTRAP_ID" "$dir/current"
		chown -h "$ADMIN:$ADMIN" "$dir/current"
	fi
}

cmd_web() {
	id "$ADMIN" >/dev/null 2>&1 || die "先运行 users"
	log "安装基础工具"
	apt-get update -qq
	apt_install curl gpg rsync ufw

	log "安装 Caddy（官方源；平时 hold，升级走 writer-caddy-upgrade）"
	install_caddy_repo
	apt-get update -qq
	# 只在没装时安装：已装的 caddy 是 hold 住的，官方源出了新版之后再对它 apt-get install 会被拒绝，
	# 重跑 web（更新 Caddyfile 与服务器端脚本）就会停在这里。版本升级只走 writer-caddy-upgrade。
	if ! dpkg-query -W -f='${Status}' caddy 2>/dev/null | grep -q 'install ok installed'; then
		apt_install caddy
	fi
	apt-mark hold caddy >/dev/null
	usermod -aG caddy "$ADMIN"
	install -d -m 0755 /etc/systemd/system/caddy.service.d
	install -m 0644 "$OPS/systemd/caddy-writer.conf" /etc/systemd/system/caddy.service.d/writer.conf

	log "目录与占位版本"
	ensure_bootstrap_release "$SITE_BASE"
	ensure_bootstrap_release "$SITE_BASE/staging"
	install -d -m 0755 -o "$ADMIN" -g "$ADMIN" "$SITE_BASE/jars" "$SITE_BASE/jars-incoming"
	# 访问日志目录：属组 adm、setgid，新文件继承 adm 组，drakeet 不用 sudo 就能读。
	# 日志文件必须属 caddy，否则 Caddy 打不开它们、起不来；这里顺带修正以前以 root 校验时建出的 root 文件。
	install -d -m 2750 -o caddy -g adm /var/log/caddy
	find /var/log/caddy -type f -exec chown caddy:adm {} + -exec chmod 0640 {} +

	log "服务器端脚本"
	local f
	for f in writer-release writer-jars-sync writer-caddy-upgrade writer-shaping; do
		install -m 0755 -o root -g root "$OPS/bin/$f" "/usr/local/bin/$f"
	done

	log "Caddy 全局配置"
	# drakeet.com 与 www.drakeet.com 的跳转规则先装好：全局配置导入它，缺了校验就不过。
	install -m 0644 -o root -g root "$OPS/caddy/drakeet.com.caddy" /etc/caddy/drakeet.com.caddy
	install -m 0644 -o root -g root "$OPS/caddy/Caddyfile" /etc/caddy/Caddyfile
	# 以 caddy 身份校验：校验会打开（不存在就新建）日志文件，以 root 运行会把它们建成 root 所有，
	# Caddy 随后就打不开；同时也验证了 caddy 用户读得到各站点导入的规则。
	runuser -u caddy -- caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null
	systemctl daemon-reload
	systemctl enable caddy >/dev/null
	# 改了 systemd 片段（RuntimeDirectory 等）需要重启而不是重载。
	systemctl restart caddy
	systemctl is-active --quiet caddy || die "Caddy 没有起来：journalctl -u caddy"

	log "防火墙（先放行 SSH 再启用）"
	ufw allow 22/tcp >/dev/null
	ufw allow 80/tcp >/dev/null
	ufw allow 443/tcp >/dev/null
	ufw allow 443/udp >/dev/null
	ufw --force enable >/dev/null
	ufw status verbose

	log "完成。下一步：部署站点、同步 JAR；然后运行 ssh --drakeet-login-verified"
}

# ---------------------------------------------------------------------------
# ssh：收紧 SSH
# ---------------------------------------------------------------------------
cmd_ssh() {
	# 要求显式确认已另开连接验证过 drakeet 能用公钥登录：收紧之后 root 就登不进来了。
	[[ "${1:-}" == --drakeet-login-verified ]] || die "先另开连接确认 drakeet 能用公钥登录，再加 --drakeet-login-verified 运行"
	[[ -s "/home/$ADMIN/.ssh/authorized_keys" ]] || die "drakeet 没有 authorized_keys"
	# 收紧之后取得 root 只剩「drakeet 登录再 sudo」一条路，先确认它是通的。
	id -nG "$ADMIN" | grep -qw sudo || die "$ADMIN 不在 sudo 组，先重跑 users"
	if [[ -f /etc/sudoers.d/90-drakeet-nopasswd ]]; then
		runuser -u "$ADMIN" -- sudo -n true || die "$ADMIN 的免密 sudo 不可用，先别收紧 SSH"
	fi
	local frag=/etc/ssh/sshd_config.d/00-writer.conf
	install -m 0644 -o root -g root "$OPS/ssh/00-writer.conf" "$frag"
	# 校验不过就撤回片段：留着坏片段，sshd 下一次重启（升级 openssh、自动重启）会起不来，谁都连不上。
	if ! sshd -t; then
		rm -f -- "$frag"
		die "sshd 配置校验失败，已撤回 $frag"
	fi
	systemctl reload ssh
	log "已收紧。请从外部确认：ssh root@writer.drakeet.com 被拒绝，ssh -v 只剩 publickey"
}

# ---------------------------------------------------------------------------
# harden：系统更新与其余加固（网站恢复之后做）
# ---------------------------------------------------------------------------
ensure_swap() {
	if ! swapon --show=NAME --noheadings | grep -qx /swapfile; then
		if [[ ! -f /swapfile ]]; then
			fallocate -l 2G /swapfile
			chmod 0600 /swapfile
			mkswap /swapfile >/dev/null
		fi
		swapon /swapfile
	fi
	grep -q '^/swapfile ' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
}

cmd_harden() {
	# swap 先于系统更新：1 GiB 内存跑 full-upgrade（新内核要生成 initramfs）容易内存不足。
	log "swap 2 GiB"
	ensure_swap

	# 自动重启（04:30）与 Caddy 受控升级（周一 05:00）都按系统时区解释，显式设定，不依赖镜像的默认值。
	log "时区"
	timedatectl set-timezone Asia/Shanghai

	log "系统更新"
	apt-get update -qq
	DEBIAN_FRONTEND=noninteractive apt-get -y -qq \
		-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold full-upgrade

	log "自动安全更新（需要重启时 04:30 自动重启）"
	apt_install unattended-upgrades
	install -m 0644 "$OPS/apt/20auto-upgrades" /etc/apt/apt.conf.d/20auto-upgrades
	install -m 0644 "$OPS/apt/52writer-unattended-upgrades" /etc/apt/apt.conf.d/52writer-unattended-upgrades
	systemctl enable --now unattended-upgrades >/dev/null

	log "journald 上限"
	install -d -m 0755 /etc/systemd/journald.conf.d
	install -m 0644 "$OPS/journald/90-writer.conf" /etc/systemd/journald.conf.d/90-writer.conf
	systemctl restart systemd-journald

	log "内核参数（BBR、HTTP/3 的 UDP 缓冲区）"
	install -m 0644 "$OPS/sysctl/90-writer.conf" /etc/sysctl.d/90-writer.conf
	sysctl --system >/dev/null

	log "Caddy 受控升级的定时器与出口整形"
	install -m 0644 "$OPS/systemd/writer-shaping.service" /etc/systemd/system/writer-shaping.service
	install -m 0644 "$OPS/systemd/writer-caddy-upgrade.service" /etc/systemd/system/writer-caddy-upgrade.service
	install -m 0644 "$OPS/systemd/writer-caddy-upgrade.timer" /etc/systemd/system/writer-caddy-upgrade.timer
	systemctl daemon-reload
	# 定时器在前：整形依赖内核模块，更可能失败，不要让它连累定时器。
	systemctl enable --now writer-caddy-upgrade.timer >/dev/null
	systemctl enable --now writer-shaping.service >/dev/null

	# 镜像若自带 snapd 而没有装任何 snap，就卸掉它，省下内存。
	if command -v snap >/dev/null 2>&1 && [[ -z "$(snap list 2>/dev/null | tail -n +2)" ]]; then
		log "卸载用不到的 snapd"
		DEBIAN_FRONTEND=noninteractive apt-get purge -y -qq snapd
	fi

	log "核对"
	chronyc -n sources 2>/dev/null | head -n 8 || true
	swapon --show
	sysctl net.ipv4.tcp_congestion_control
	systemctl list-timers --no-pager | grep -E 'apt-daily|writer-caddy' || true
	if [[ -f /var/run/reboot-required ]]; then
		log "系统要求重启（$(tr '\n' ' ' < /var/run/reboot-required.pkgs 2>/dev/null)）；挑网站访问少的时候 systemctl reboot"
	fi
	log "完成"
}

main() {
	require_root
	require_ubuntu
	case "${1:-}" in
		users) cmd_users ;;
		web) cmd_web ;;
		ssh) shift; cmd_ssh "$@" ;;
		harden) cmd_harden ;;
		*) die "用法：provision.sh <users|web|ssh|harden>" ;;
	esac
}

main "$@"
