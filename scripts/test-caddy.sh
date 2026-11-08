#!/usr/bin/env bash
# 用本机 Caddy 跑完整的 URL 合同（docs/rebuild.md 5.5）：改了 caddy/site.caddy 或 ops/contract.tsv 之后自查用。只在本机，
# 不连接服务器。部署时 scripts/deploy.sh 会在服务器上对线上再跑一遍，这里是提交之前的那一遍。
# drakeet.com 与 www.drakeet.com 的跳转规则（ops/caddy/drakeet.com.caddy，属于服务器的全局配置）与它的合同
# ops/contract-drakeet.com.tsv 也在这里一起跑：它们不随站点版本发布，部署时不会检查，改了只能靠这一遍（docs/rebuild.md 5.7）。
#
#   scripts/test-caddy.sh                    从工作区构建站点（scripts/build.sh --worktree --no-check），再起 Caddy 跑合同
#   scripts/test-caddy.sh --public <目录>    用已经构建好的产物（例如 scripts/build-page.sh 的输出），不再构建
#   scripts/test-caddy.sh --port <端口>      指定监听的端口（默认挑一个空闲的高位端口）
#   scripts/test-caddy.sh --keep             结束后保留测试台目录（产物、配置与 Caddy 日志），便于排查
#   scripts/test-caddy.sh --verbose          逐行打印合同的结果
#
# 做法：
#   1. 按服务器的目录结构在临时目录里搭一个版本（5.3）：site/releases/<版本号>/ 下放 public/（产物）、caddy/site.caddy、
#      checks/（合同表与检查脚本，均取自工作区），site/current 软链接指向它；JAR 目录用临时目录模拟，放三个以 desktop2.json
#      里的版本命名的假 JAR；
#   2. 写一份只监听 127.0.0.1、只用 HTTP 的全局配置，像服务器上的 /etc/caddy/Caddyfile 一样
#      import <版本目录>/caddy/site.caddy <版本目录>；JAR 目录经 WRITER_JARS_DIR 传给站点规则。drakeet.com 与
#      www.drakeet.com 的站点块同样导入 ops/caddy/drakeet.com.caddy 的副本，同一个端口按 Host 分开；
#   3. 先校验配置，再在后台起 Caddy，跑 ops/contract.py：writer.drakeet.com 跑 ops/contract.tsv，drakeet.com 与
#      www.drakeet.com 各跑一遍 ops/contract-drakeet.com.tsv。结束时（包括出错与中断）停掉这个 Caddy、删掉临时目录。
# 产物里缺了合同要求的页面，对应的行就不通过：页面已经全部迁完，不再补占位页。
#
# Caddy 用本机缓存里与服务器同版本的二进制（已核对过 SHA-512）；用环境变量 CADDY 可以换成别的路径。
set -euo pipefail

cd "$(dirname "$0")/.."
readonly CADDY="${CADDY:-$HOME/Library/Caches/writer-site/caddy-2.11.9/caddy}"
readonly HOST=writer.drakeet.com
readonly RELEASE_ID=20000101T000000Z-testbench

die() {
	echo "test-caddy: $*" >&2
	exit 1
}

public_src=""
port=""
keep=0
verbose=()
while (($#)); do
	case "$1" in
		--public)
			shift
			[[ $# -gt 0 && -d "$1" ]] || die "--public 后面要跟已经构建好的产物目录"
			public_src="$(cd "$1" && pwd)"
			;;
		--port)
			shift
			[[ $# -gt 0 && "$1" =~ ^[0-9]+$ ]] || die "--port 后面要跟端口号"
			port="$1"
			;;
		--keep) keep=1 ;;
		--verbose) verbose=(--verbose) ;;
		*) die "未知参数：$1（用法见脚本开头的注释）" ;;
	esac
	shift
done

[[ -x "$CADDY" ]] || die "找不到 Caddy：${CADDY}（用环境变量 CADDY 指定与服务器同版本的二进制）"

bench="$(mktemp -d "${TMPDIR:-/tmp}/writer-caddy-test.XXXXXX")"
caddy_pid=""
cleanup() {
	if [[ -n "$caddy_pid" ]]; then
		kill "$caddy_pid" 2>/dev/null || true
		wait "$caddy_pid" 2>/dev/null || true
	fi
	if ((keep)); then
		echo "测试台保留在 ${bench}（Caddy 日志：$bench/caddy.log）"
	else
		rm -rf -- "$bench"
	fi
}
trap cleanup EXIT
# 被中断或终止时也走正常退出，保证上面的清理一定执行、不留下在后台监听的 Caddy。
trap 'exit 130' INT TERM

# 1. 版本目录：与服务器上 /srv/writer.drakeet.com/releases/<版本号>/ 的结构相同。
release="$bench/site/releases/$RELEASE_ID"
mkdir -p "$release/caddy" "$release/checks" "$bench/jars" "$bench/data" "$bench/config"
if [[ -n "$public_src" ]]; then
	mkdir -p "$release/public"
	cp -R "$public_src/." "$release/public/"
else
	scripts/build.sh --worktree --no-check --out "$release/public"
fi
cp caddy/site.caddy "$release/caddy/site.caddy"
cp ops/contract.tsv ops/contract.py "$release/checks/"
# drakeet.com 的规则在服务器上是 /etc/caddy/drakeet.com.caddy，与站点版本无关，放在测试台的根目录。
cp ops/caddy/drakeet.com.caddy "$bench/drakeet.com.caddy"
ln -s "releases/$RELEASE_ID" "$bench/site/current"

# 假 JAR：名字与服务器上 writer-jars-sync 放进来的一致，版本取自这次产物里的 desktop2.json。
version="$(python3 -I -c 'import json, sys; print(json.load(open(sys.argv[1]))["version"])' "$release/public/desktop2.json")"
for platform in Windows-x64 macOS-x64 macOS-aarch64; do
	echo "测试台的假 JAR，不是真正的安装包" >"$bench/jars/PureWriter2-$version-$platform.jar"
done

# 2. 本机的全局配置：只监听 127.0.0.1，只用 HTTP；不开管理接口、不保存配置，数据目录都在测试台里。
if [[ -z "$port" ]]; then
	port="$(python3 -I -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"
fi
cat >"$bench/Caddyfile" <<EOF
{
	admin off
	auto_https off
	persist_config off
	storage file_system $bench/data
}

http://$HOST:$port {
	bind 127.0.0.1
	import $bench/site/current/caddy/site.caddy $bench/site/current
}

http://drakeet.com:$port, http://www.drakeet.com:$port {
	bind 127.0.0.1
	import $bench/drakeet.com.caddy
}
EOF

caddy_env=(env WRITER_JARS_DIR="$bench/jars" XDG_DATA_HOME="$bench/data" XDG_CONFIG_HOME="$bench/config")
if ! "${caddy_env[@]}" "$CADDY" validate --config "$bench/Caddyfile" --adapter caddyfile >"$bench/validate.log" 2>&1; then
	tail -n 20 "$bench/validate.log" >&2
	die "Caddy 拒绝了这份站点规则"
fi

# 3. 后台起 Caddy，等端口就绪后跑合同。
"${caddy_env[@]}" "$CADDY" run --config "$bench/Caddyfile" --adapter caddyfile >"$bench/caddy.log" 2>&1 &
caddy_pid=$!
ready=0
for _ in $(seq 1 50); do
	if ! kill -0 "$caddy_pid" 2>/dev/null; then
		tail -n 20 "$bench/caddy.log" >&2
		die "Caddy 没有起来"
	fi
	if python3 -I -c 'import socket, sys; socket.create_connection(("127.0.0.1", int(sys.argv[1])), 1).close()' "$port" 2>/dev/null; then
		ready=1
		break
	fi
	sleep 0.2
done
((ready)) || die "Caddy 在 10 秒内没有开始监听 127.0.0.1:$port"

echo "test-caddy: Caddy $("$CADDY" version | cut -d' ' -f1) 已在 127.0.0.1:$port 上起来，开始跑合同"
status=0
python3 -I "$release/checks/contract.py" --local "http://127.0.0.1:$port" --host "$HOST" "${verbose[@]+"${verbose[@]}"}" || status=$?
for host in drakeet.com www.drakeet.com; do
	python3 -I ops/contract.py --contract ops/contract-drakeet.com.tsv --local "http://127.0.0.1:$port" --host "$host" \
		"${verbose[@]+"${verbose[@]}"}" || status=$?
done
exit "$status"
