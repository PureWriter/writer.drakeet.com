#!/usr/bin/env bash
# 旧站的部署脚本（第 A 步到第 C 步之间使用；第 C 步由新站的 scripts/deploy.sh 取代，接口相同）。
# 这份文件在旧站的 master 里位于 scripts/deploy.sh。桌面版 release.sh 的 deploy 步骤与手动部署都调用它：
#   scripts/deploy.sh             部署当前已提交的 HEAD 到正式站
#   scripts/deploy.sh --rollback  把正式站切回上一版
#
# 做法：从已提交的 HEAD 打包网站文件（不含仓库文件），用 rsync 上传为服务器上的一个新版本
# （未变的文件与上一版做硬链接），再由服务器端的 writer-release 原子切换并重载 Caddy；
# 最后对线上做冒烟检查，失败就自动切回上一版。工作区里未提交的改动不影响部署。
set -euo pipefail

readonly HOST=drakeet@writer.drakeet.com
readonly BASE=/srv/writer.drakeet.com
readonly SITE=https://writer.drakeet.com
readonly SSH=(ssh -o BatchMode=yes)

cd "$(dirname "$0")/.."

die() {
	echo "deploy: $*" >&2
	exit 1
}

if [[ "${1:-}" == --rollback ]]; then
	"${SSH[@]}" "$HOST" writer-release rollback prod
	exit 0
fi
[[ $# -eq 0 ]] || die "用法：scripts/deploy.sh [--rollback]"

branch="$(git rev-parse --abbrev-ref HEAD)"
[[ "$branch" == master ]] || die "只从 master 部署（当前在 $branch）"

id="$(date -u +%Y%m%dT%H%M%SZ)-$(git rev-parse --short=8 HEAD)"
work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT

# 1. 从已提交的 HEAD 取出文件。冒烟检查要比对的版本号在切换之前就取好：
#    这一步若在切换之后才失败，set -e 会让脚本直接退出，跳过冒烟检查与回滚。
mkdir -p "$work/src" "$work/release/public" "$work/release/caddy"
git archive --format=tar HEAD | tar -x -C "$work/src"
expected_version="$(jq -r .version "$work/src/desktop2.json")"
[[ -n "$expected_version" && "$expected_version" != null ]] || die "读不出 desktop2.json 的版本号"

# 2. 只发布网站文件：仓库文件、Jekyll 遗留与本脚本自己都不进网站根目录。
#    排除列表写成文件再传给 rsync：macOS 自带的 openrsync 与 GNU rsync 都认这种写法。
cat > "$work/excludes" <<'EOF'
/.gitignore
/AGENTS.md
/CLAUDE.md
/CNAME
/Gemfile
/_config.yml
/_layouts/
/_sass/
/another-page.md
/assets/
/caddy/
/docs/
/jekyll-theme-minimal.gemspec
/script/
/scripts/
/sources/
EOF
rsync -rlp --exclude-from="$work/excludes" "$work/src/" "$work/release/public/"
cp "$work/src/caddy/site.caddy" "$work/release/caddy/site.caddy"
# 权限在本地统一好再上传（openrsync 不支持 --chmod=D755,F644 这种写法）。
find "$work/release" -type d -exec chmod 0755 {} +
find "$work/release" -type f -exec chmod 0644 {} +

# 3. 上传为新版本：内容与当前版本相同的文件直接做硬链接，每次实际传输的只有改动。
#    按内容比较（--checksum）、不保留修改时间（-rlp，不用 -a）：git archive 把所有文件的时间都设成提交时间，
#    按时间比较的话每次部署都会整站重传；不保留时间，没改的文件沿用上一版的 inode，ETag 与 Last-Modified 也不变。
rsync -rlp --checksum --delete --link-dest="$BASE/current/" \
	"$work/release/" "$HOST:$BASE/releases/$id/"

# 4. 原子切换并重载 Caddy；Caddy 拒绝新规则时 writer-release 会自己切回。
"${SSH[@]}" "$HOST" writer-release activate prod "$id"

# 5. 冒烟检查：关键地址的状态码与类型；任何一项不符就切回上一版。
failures=()
check() { # check <路径> <期望状态码> [<期望 Content-Type 前缀>]
	local path="$1" want="$2" type="${3:-}" got
	got="$(curl -sS -o /dev/null --max-time 30 -w '%{http_code} %{content_type}' "$SITE$path" || echo "000 -")"
	[[ "${got%% *}" == "$want" ]] || { failures+=("$path：期望 $want，实际 ${got%% *}"); return; }
	[[ -z "$type" || "${got#* }" == "$type"* ]] || failures+=("$path：期望 $type，实际 ${got#* }")
}
check /.well-known/apple-app-site-association 200 application/json
check /desktop2.json 200 application/json
check / 200 text/html
check /desktop2 200 text/html
check /images/papers/0.jpg 200 image/jpeg
check /drives/oauth/OneDrive_ja 200 text/html
check /.git/config 404
check /no-such-page-for-deploy-check 404
live_version="$(curl -sS --max-time 30 "$SITE/desktop2.json" | jq -r .version 2>/dev/null || true)"
[[ "$live_version" == "$expected_version" ]] || failures+=("desktop2.json：期望版本 $expected_version，实际 $live_version")

if ((${#failures[@]})); then
	printf '冒烟检查失败：\n' >&2
	printf '  %s\n' "${failures[@]}" >&2
	"${SSH[@]}" "$HOST" writer-release rollback prod >&2 || true
	die "已切回上一版"
fi
echo "部署完成：$id"
