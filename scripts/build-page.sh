#!/usr/bin/env bash
# 只构建指定的页面，给迁移或修改单个页面时自查用（docs/content.md 第三节）。
#   scripts/build-page.sh --out <目录> <content 下的文件或目录>...
# 例如：scripts/build-page.sh --out /tmp/site-desktop content/desktop
#
# 做法：把骨架（模板、样式、静态文件、配置等，除 content/ 以外的全部）与指定的页面复制到一个私有的临时目录里构建，
# 其余页面不参与。几个人同时迁移不同页面时，谁也不会被别人写到一半的文件挡住。站内链接检查要全站页面齐了才有意义，
# 这里不做；页面齐了以后用 scripts/build.sh --worktree 做全站构建与检查。
set -euo pipefail

cd "$(dirname "$0")/.."

die() {
	echo "build-page: $*" >&2
	exit 1
}

[[ "${1:-}" == --out && $# -ge 3 ]] || die "用法：scripts/build-page.sh --out <目录> <content 下的文件或目录>..."
out="$2"
shift 2

work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$work/src/content"
rsync -a --exclude '/.git' --exclude '/public/' --exclude '/content/' ./ "$work/src/"
# 俄文首页的开关文件总要带上，否则 Hugo 会为俄文生成一个空首页。
cp content/_index.ru.md "$work/src/content/"
for path in "$@"; do
	[[ "$path" == content/* && -e "$path" ]] || die "不是 content 下存在的文件或目录：$path"
	rsync -a --relative "./$path" "$work/src/"
done
scripts/build.sh --source "$work/src" --no-check --out "$out"
