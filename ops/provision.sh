#!/usr/bin/env bash
# 官网服务器初始化（Ubuntu 26.04 LTS，阿里云 ECS）。以 root 运行，每一步都可以重复执行。
#
# 准备：把仓库的 ops/ 目录传到服务器的 /root/writer-provision/ops/，并在 /root/writer-provision/ 放：
#   authorized_keys   drakeet 账户允许登录的公钥（不入库）
#   drakeet.com/      drakeet.com 与 www.drakeet.com 的静态页（从旧服务器备份，不入库；没有则跳过）
#
# 顺序（防止把自己锁在外面，见 docs/rebuild.md 5.3）：
#   provision.sh users      建 drakeet 账户、公钥、重建期间的免密 sudo
#   —— 另开一个连接确认 ssh -o BatchMode=yes drakeet@writer.drakeet.com true 成功 ——
#   provision.sh web        装 Caddy，建目录与占位版本，装服务器端脚本，启用防火墙（先放行 22）
#   provision.sh ssh --drakeet-login-verified
#                           收紧 SSH：只认公钥、禁止 root、只允许 drakeet
#   provision.sh harden     系统更新、自动更新、swap、日志上限、BBR、出口整形、Caddy 受控升级的定时器
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
	usermod -aG adm "$ADMIN"

	install -d -m 0700 -o "$ADMIN" -g "$ADMIN" "/home/$ADMIN/.ssh"
	install -m 0600 -o "$ADMIN" -g "$ADMIN" "$keys" "/home/$ADMIN/.ssh/authorized_keys"

	# 重建期间的免密 sudo。文件名与旧服务器相同，收尾时的收回命令不用改。先校验语法再安装，写错也不会弄坏 sudo。
	local tmp
	tmp="$(mktemp)"
	echo "$ADMIN ALL=(ALL) NOPASSWD:ALL" > "$tmp"
	visudo -cf "$tmp" >/dev/null
	install -m 0440 -o root -g root "$tmp" /etc/sudoers.d/90-drakeet-nopasswd
	rm -f -- "$tmp"

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
	apt_install caddy
	apt-mark hold caddy >/dev/null
	usermod -aG caddy "$ADMIN"
	install -d -m 0755 /etc/systemd/system/caddy.service.d
	install -m 0644 "$OPS/systemd/caddy-writer.conf" /etc/systemd/system/caddy.service.d/writer.conf

	log "目录与占位版本"
	ensure_bootstrap_release "$SITE_BASE"
	ensure_bootstrap_release "$SITE_BASE/staging"
	install -d -m 0755 -o "$ADMIN" -g "$ADMIN" "$SITE_BASE/jars" "$SITE_BASE/jars-incoming"
	install -d -m 0755 -o "$ADMIN" -g "$ADMIN" /srv/legacy /srv/legacy/drakeet.com
	if [[ -d "$INPUT/drakeet.com" ]]; then
		cp -R "$INPUT/drakeet.com/." /srv/legacy/drakeet.com/
		chown -R "$ADMIN:$ADMIN" /srv/legacy/drakeet.com
		find /srv/legacy/drakeet.com -type f -exec chmod 0644 {} +
	fi
	# 访问日志目录：属组 adm、setgid，新文件继承 adm 组，drakeet 不用 sudo 就能读。
	install -d -m 2750 -o caddy -g adm /var/log/caddy
	chgrp -R adm /var/log/caddy
	find /var/log/caddy -type f -exec chmod 0640 {} +

	log "服务器端脚本"
	local f
	for f in writer-release writer-jars-sync writer-caddy-upgrade writer-shaping; do
		install -m 0755 -o root -g root "$OPS/bin/$f" "/usr/local/bin/$f"
	done

	log "Caddy 全局配置"
	install -m 0644 -o root -g root "$OPS/caddy/Caddyfile" /etc/caddy/Caddyfile
	caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null
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
	install -m 0644 -o root -g root "$OPS/ssh/00-writer.conf" /etc/ssh/sshd_config.d/00-writer.conf
	sshd -t
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
	log "系统更新"
	apt-get update -qq
	DEBIAN_FRONTEND=noninteractive apt-get -y -qq \
		-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold full-upgrade

	log "自动安全更新（需要重启时 04:30 自动重启）"
	apt_install unattended-upgrades
	install -m 0644 "$OPS/apt/20auto-upgrades" /etc/apt/apt.conf.d/20auto-upgrades
	install -m 0644 "$OPS/apt/52writer-unattended-upgrades" /etc/apt/apt.conf.d/52writer-unattended-upgrades
	systemctl enable --now unattended-upgrades >/dev/null

	log "swap 2 GiB"
	ensure_swap

	log "journald 上限"
	install -d -m 0755 /etc/systemd/journald.conf.d
	install -m 0644 "$OPS/journald/90-writer.conf" /etc/systemd/journald.conf.d/90-writer.conf
	systemctl restart systemd-journald

	log "内核参数（BBR、HTTP/3 的 UDP 缓冲区）"
	install -m 0644 "$OPS/sysctl/90-writer.conf" /etc/sysctl.d/90-writer.conf
	sysctl --system >/dev/null

	log "出口整形与 Caddy 受控升级的定时器"
	install -m 0644 "$OPS/systemd/writer-shaping.service" /etc/systemd/system/writer-shaping.service
	install -m 0644 "$OPS/systemd/writer-caddy-upgrade.service" /etc/systemd/system/writer-caddy-upgrade.service
	install -m 0644 "$OPS/systemd/writer-caddy-upgrade.timer" /etc/systemd/system/writer-caddy-upgrade.timer
	systemctl daemon-reload
	systemctl enable --now writer-shaping.service >/dev/null
	systemctl enable --now writer-caddy-upgrade.timer >/dev/null

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
