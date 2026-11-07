#!/usr/bin/env bash
# 新站的部署脚本（docs/rebuild.md 第六节；日常操作见 docs/operations.md）。桌面版 release.sh 的 deploy 步骤与手动部署都调用它：
#   scripts/deploy.sh                               部署已提交的 HEAD 到正式站 writer.drakeet.com（只接受 master）
#   scripts/deploy.sh --staging                     部署已提交的 HEAD 到预发站 writer2.drakeet.com（任何分支都可以）
#   scripts/deploy.sh --rollback [--staging]        把正式站（或预发站）切回上一版；再执行一次就回到刚才的版本
#   scripts/deploy.sh --first-cutover-from-rebuild  只用于第 C 步的首次切换：放行从 rebuild 分支部署正式站，要求 master
#                                                   已经合进 rebuild、而这个提交还不在 master 里。第 C 步完成后删掉这个参数
#
# 做法：
#   1. 开头取一次完整的提交号，之后用到的一切都取自这个提交：git archive 解到临时目录，用解出来的 scripts/build.sh 构建并
#      检查（Hugo 的版本、检查脚本与 ops/ 下的检查配置因此也是这个提交的），站点规则与 URL 合同也从这同一份里取。
#      工作区里未提交的改动、构建期间别人新做的提交，都影响不到这次部署；
#   2. 版本目录由三部分组成：public/（产物）、caddy/site.caddy（站点规则）、checks/（URL 合同表与检查脚本）；
#   3. rsync 上传为服务器上的一个新版本：按内容比较、不保留修改时间，内容未变的文件与当前版本做硬链接，实际只传改动；
#   4. 记下服务器上切换前的版本，再 ssh 调用 writer-release 原子切换 current 并重载 Caddy（Caddy 拒绝新规则时它会自己切回
#      原版本）。它报告失败时，先查服务器上 current 实际指向哪个版本：已是这次的版本就照常检查，否则如实报告；
#   5. 在服务器上对这个环境跑 URL 合同（按主机名连本机 443，不经公网）；正式站另从本机核对线上 desktop2.json 的版本
#      等于这次提交里的版本（与旧站相同）。任何一项不通过都自动切回切换前的那个版本并报错。
# 所有操作（含 --rollback）都先取得部署锁，同一时间只有一次部署在进行；锁已存在时一律拒绝，遗留的锁要手动移除（见 acquire_lock）。
set -euo pipefail

readonly HOST=drakeet@writer.drakeet.com
readonly SITE_BASE=/srv/writer.drakeet.com
# 连不上服务器时 15 秒放弃；连上之后每 15 秒探一次，连续 4 次没有回应（约一分钟）就断开，网络中断时部署不会无限期挂着。
# BatchMode 不弹口令提示，密钥不行就直接失败。rsync 经 -e 用同一组选项。
readonly SSH=(ssh -o BatchMode=yes -o ConnectTimeout=15 -o ServerAliveInterval=15 -o ServerAliveCountMax=4)

cd "$(dirname "$0")/.."

die() {
	echo "deploy: $*" >&2
	exit 1
}

usage="用法：scripts/deploy.sh [--staging] [--rollback] | scripts/deploy.sh --first-cutover-from-rebuild"
staging=0
rollback=0
cutover=0
while (($#)); do
	case "$1" in
		--staging) staging=1 ;;
		--rollback) rollback=1 ;;
		--first-cutover-from-rebuild) cutover=1 ;;
		*) die "$usage" ;;
	esac
	shift
done
if ((cutover && (staging || rollback))); then
	die "--first-cutover-from-rebuild 只用于部署正式站，不与 --staging、--rollback 合用"
fi

# 两个环境的差别只在服务器上的目录与主机名（docs/operations.md 第 4 节）。
if ((staging)); then
	env=staging
	base="$SITE_BASE/staging"
	site=writer2.drakeet.com
else
	env=prod
	base="$SITE_BASE"
	site=writer.drakeet.com
fi
status_command="ssh $HOST writer-release status $env"

# 退出时（包括出错与中断）删掉临时目录、释放部署锁。
work=""
lock_dir=""
lock_held=0
cleanup() {
	if [[ -n "$work" ]]; then
		rm -rf -- "$work"
	fi
	if ((lock_held)); then
		rm -rf -- "$lock_dir"
	fi
}
trap cleanup EXIT

# 切换开始之后被中断：服务器上可能已经是新版本，也可能还是原版本，检查没有做完，也没有自动回滚。不猜，只给出查看状态与
# 切回切换前版本的命令（restore_command，见第 4 步）：它指定了目标版本，current 无论是哪个版本都可以直接运行。
activating=0
on_signal() {
	if ((activating)); then
		{
			echo "deploy: 切换开始之后被中断：切换后的检查没有做完，也没有自动回滚。"
			echo "  查看服务器上的版本：$status_command"
			echo "  要回到切换前的 $before：$restore_command"
		} >&2
	fi
	exit "$1"
}
trap 'on_signal 130' INT
trap 'on_signal 143' TERM

# 部署锁。部署都从这台 Mac 发起：桌面版 release.sh 与手动部署，正式站用主目录，预发站用 rebuild 工作树。两次部署交错时，
# 失败的那次会把后完成的那次一起回滚掉，所以同一时间只许一次。锁放在主目录与工作树共用的 git 公共目录里，用 mkdir 的
# 原子性实现（macOS 没有 flock），锁里记下进程号、开始时间与部署内容。
# 锁已存在时一律拒绝，不自动接管遗留的锁。正常退出、出错与 INT、TERM、HUP 都会经 trap 释放锁，遗留锁只在部署进程被强杀
# （kill -9）或机器死机后才会出现，手动移除的代价很小。自动接管却要先删掉旧锁再重建：两个进程同时接管同一把遗留锁时，
# 后删的那个会删掉先到者刚建好的锁，两边一起进入部署。
acquire_lock() {
	local what="$1" common owner holder
	common="$(git rev-parse --git-common-dir)"
	common="$(cd "$common" && pwd -P)"
	lock_dir="$common/writer-deploy.lock"
	if mkdir "$lock_dir" 2>/dev/null; then
		lock_held=1
		printf 'pid=%s\nstarted=%s\nwhat=%s\n' "$$" "$(date '+%Y-%m-%d %H:%M:%S %z')" "$what" >"$lock_dir/owner"
		return
	fi
	# 记录只读一次：持有者随时可能结束并删掉锁，分两次读，打印出来的与判断用的可能不是同一份。
	owner="$(cat "$lock_dir/owner" 2>/dev/null || true)"
	holder="$(sed -n 's/^pid=//p' <<<"$owner")"
	if [[ -z "$holder" ]]; then
		die "部署锁 $lock_dir 已存在，但里面没有持有者的记录（可能正在建立）；确认没有部署在进行后手动移除它再试"
	fi
	sed 's/^/    /' <<<"$owner" >&2
	if kill -0 "$holder" 2>/dev/null; then
		die "另一次部署正在进行（锁 $lock_dir，内容见上），不能同时部署；如果确认进程 $holder 不是部署，手动移除这把锁再试"
	fi
	{
		echo "deploy: 部署锁 $lock_dir 是遗留的（内容见上）：持有它的进程 $holder 已不在，多半是上次部署被强杀或机器死机留下的。"
		echo "  请先确认没有部署在进行，再移除它后重试：rm -rf '$lock_dir'"
	} >&2
	exit 1
}

if ((rollback)); then
	acquire_lock "回滚 $site"
	"${SSH[@]}" "$HOST" writer-release rollback "$env"
	exit 0
fi

# <a> 是 <b> 的祖先时返回 0，不是时返回 1；git 出错（例如没有这个分支）时不当作「不是」，直接拒绝部署。
is_ancestor() {
	local status=0
	git merge-base --is-ancestor "$1" "$2" || status=$?
	case "$status" in
		0 | 1) return "$status" ;;
		*) die "无法判断 $1 是否是 $2 的祖先（git merge-base 退出状态 $status），拒绝部署" ;;
	esac
}

# 这次部署的提交，只取这一次；下面的分支判断、构建、规则与合同都用它，不再看 HEAD。
commit="$(git rev-parse --verify 'HEAD^{commit}')"
short="$(git rev-parse --short=8 "$commit")"
branch="$(git rev-parse --abbrev-ref HEAD)"

# 分支要求（第六节）：正式站只接受 master，唯一的例外是第 C 步的首次切换；预发站任何分支都可以。
if [[ "$env" == prod ]]; then
	if ((cutover)); then
		[[ "$branch" == rebuild ]] || die "--first-cutover-from-rebuild 只放行 rebuild 分支（当前在 $branch）"
		# master 已经包含这个提交，说明首次切换已经完成、master 已快进：之后都从 master 部署。
		if is_ancestor "$commit" master; then
			die "这个提交已经在 master 里，首次切换已经完成；请在 master 上运行 scripts/deploy.sh"
		fi
		# master 必须已经合进来：桌面版发版会在 master 上更新 desktop2.json，没合进来就会把过时的发版数据部署上线。
		if ! is_ancestor master "$commit"; then
			die "master 还没有合进 rebuild（master 不是 $short 的祖先）；先在 rebuild 上 git merge master，提交后再部署"
		fi
	elif [[ "$branch" != master ]]; then
		die "正式站只从 master 部署（当前在 $branch）；预发站用 --staging，第 C 步的首次切换用 --first-cutover-from-rebuild"
	fi
fi

id="$(date -u +%Y%m%dT%H%M%SZ)-$short"
acquire_lock "部署 $branch 的 $short（$commit）到 $site，版本号 $id"
work="$(mktemp -d)"
echo "deploy: 部署 $branch 的 $short 到 $site（版本号 $id）"

# 1. 解出这个提交，用其中的 build.sh 构建并检查。--worktree 让它直接构建所在的这份目录，也就是刚解出来的提交，
#    不再去读 git；构建用的 scripts/hugo、scripts/check.py 与 ops/ 下的检查配置都随之取自同一个提交。
src="$work/src"
release="$work/release"
mkdir -p "$src" "$release/caddy" "$release/checks"
git archive --format=tar "$commit" | tar -x -C "$src"
"$src/scripts/build.sh" --worktree --out "$release/public"

# 2. 站点规则与 URL 合同取自同一份。正式站要比对的版本号在切换之前就取好：切换之后若在这里失败，
#    set -e 会让脚本直接退出，跳过检查与回滚。
cp "$src/caddy/site.caddy" "$release/caddy/site.caddy"
cp "$src/ops/contract.tsv" "$src/ops/contract.py" "$release/checks/"
expected_version="$(jq -r .version "$release/public/desktop2.json")"
[[ -n "$expected_version" && "$expected_version" != null ]] || die "读不出 desktop2.json 的版本号"

# 权限在本地统一好再上传（macOS 自带的 openrsync 不支持 --chmod=D755,F644 这种写法）。
find "$release" -type d -exec chmod 0755 {} +
find "$release" -type f -exec chmod 0644 {} +

# 3. 上传为新版本：内容与当前版本相同的文件直接做硬链接，每次实际传输的只有改动。
#    按内容比较（--checksum）、不保留修改时间（-rlp，不用 -a）：构建产物的时间每次都会变，按时间比较就得整站重传；
#    不保留时间，没改的文件沿用上一版的 inode，ETag 与 Last-Modified 也不变。这些选项 openrsync 与 GNU rsync 都认。
rsync -rlp --checksum --delete -e "${SSH[*]}" --link-dest="$base/current/" "$release/" "$HOST:$base/releases/$id/"

# 服务器上 current 实际指向的版本号；查不到（例如连不上）时输出空串。
server_current() {
	"${SSH[@]}" "$HOST" writer-release status "$env" 2>/dev/null | sed -n 's/^current:[[:space:]]*//p' || true
}

# 4. 原子切换并重载 Caddy。先记下切换前的版本 before：检查不通过时用 writer-release activate 明确切回它，不用 rollback。
#    rollback 切到服务器上记录的 previous，而 writer-release 在切换、重载成功之后才写 previous；那之前失败（或 ssh 断开）
#    时 current 已是新版本，previous 却还是更早的一版。activate 指定目标版本，current 已是它时什么都不做，所以中断后的提示
#    也可以直接给出这条命令。
#    writer-release 非零退出不等于线上仍是原版本：切换与重载成功之后的步骤也可能失败，ssh 也可能在返回之前断开。所以先查
#    current 实际指向哪个版本，有凭据再下结论；不加重试。
before="$(server_current)"
[[ -n "$before" ]] || die "查不到服务器上的 current 指向哪个版本，没有切换；请运行 $status_command 核对"
restore_command="ssh $HOST writer-release activate $env $before"
activating=1
if ! "${SSH[@]}" "$HOST" writer-release activate "$env" "$id"; then
	live="$(server_current)"
	if [[ "$live" == "$id" ]]; then
		echo "deploy: writer-release 报告失败，但服务器上的 current 已经是 $id；照常做切换后的检查，不通过再切回 $before" >&2
	elif [[ -n "$live" ]]; then
		die "切换失败：服务器上的 current 是 $live，不是这次的 $id（详情见上面 writer-release 的输出）"
	else
		die "切换失败，也查不到服务器上的 current 指向哪个版本；请运行 $status_command 核对，要回到切换前的版本就运行 $restore_command"
	fi
fi

# 5. 切换之后的检查。这里不能让 set -e 中途退出：先收集结果，再决定是否回滚。
failures=()
echo "deploy: 在服务器上对 $site 跑 URL 合同"
if ! "${SSH[@]}" "$HOST" python3 -I "$base/releases/$id/checks/contract.py" --site "$site"; then
	failures+=("URL 合同检查不通过（逐条报告见上）")
fi
if [[ "$env" == prod ]]; then
	# curl -f 让 4xx、5xx 与传输中断都算失败；curl 不跟随跳转，3xx 的正文不是带版本号的 JSON，jq -e 读不出 version，同样算失败。
	if live_json="$(curl -fsS --max-time 30 "https://$site/desktop2.json")" && live_version="$(jq -er .version <<<"$live_json")"; then
		[[ "$live_version" == "$expected_version" ]] || failures+=("desktop2.json：期望版本 $expected_version，实际 $live_version")
	else
		failures+=("从本机读取 https://$site/desktop2.json 失败，或其中没有版本号（见上面 curl 或 jq 的输出）")
	fi
fi

if ((${#failures[@]})); then
	printf '部署后的检查不通过：\n' >&2
	printf '  %s\n' "${failures[@]}" >&2
	"${SSH[@]}" "$HOST" writer-release activate "$env" "$before" >&2 \
		|| die "自动切回 $before 也失败了：请运行 $status_command 核对，再手动运行 $restore_command"
	die "已切回切换前的版本 $before"
fi
echo "deploy: 部署完成：$site 现在是 $id"
