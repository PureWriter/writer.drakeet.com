#!/usr/bin/env bash
# 构建站点并跑不需要服务器的检查（docs/rebuild.md 第六节）。
#   scripts/build.sh                     从已提交的 HEAD 构建到 public/（部署用的就是这种构建）
#   scripts/build.sh --worktree          从工作区构建，包括未提交的改动（写页面时自查用）
#   scripts/build.sh --out <目录>        产物写到指定目录；几个构建可以同时进行，互不干扰
#   scripts/build.sh --update-expected   检查通过后，用这次的产物重写 ops/expected-files.txt（有意增删页面时用）
#   scripts/build.sh --no-check          跳过第 5 步的检查，只在页面还没迁移齐、写单个页面自查时用；部署永远带检查
#   scripts/build.sh --source <目录>     从指定目录构建（scripts/build-page.sh 用它构建只含部分页面的副本）
#
# 构建警告一律视为错误。产物之外还会生成：根目录的 desktop2.json（原样复制）、.well-known/security.txt（Expires 取
# 构建时起一年内）、文本文件的 brotli 与 gzip 预压缩版本（Caddy 按浏览器支持直接发送；没有 brotli 时只跳过 .br）。
set -euo pipefail

cd "$(dirname "$0")/.."
readonly REPO="$PWD"

die() {
	echo "build: $*" >&2
	exit 1
}

from_worktree=0
source_dir=""
out="$REPO/public"
update_expected=0
run_checks=1
while (($#)); do
	case "$1" in
		--worktree) from_worktree=1 ;;
		--source)
			shift
			[[ $# -gt 0 ]] || die "--source 后面要跟目录"
			source_dir="$1"
			;;
		--out)
			shift
			[[ $# -gt 0 ]] || die "--out 后面要跟目录"
			out="$1"
			;;
		--update-expected) update_expected=1 ;;
		--no-check) run_checks=0 ;;
		*) die "未知参数：$1" ;;
	esac
	shift
done

# 产物目录每次都会先清空：拒绝明显写错的目录（根目录、家目录、本仓库或它的上级、任何 git 仓库），免得误删。
out_abs="$(mkdir -p "$out" && cd "$out" && pwd -P)"
case "$REPO/" in
	"$out_abs"/*) die "--out 不能是本仓库或它的上级目录：$out_abs" ;;
esac
[[ "$out_abs" != / && "$out_abs" != "$HOME" ]] || die "--out 不能是 $out_abs"
[[ ! -e "$out_abs/.git" ]] || die "--out 指向一个 git 仓库：$out_abs"
out="$out_abs"

work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT

# 1. 源文件：默认取已提交的 HEAD，部署内容与提交历史严格一致，工作区里的草稿不影响部署。
if [[ -n "$source_dir" ]]; then
	src="$source_dir"
elif ((from_worktree)); then
	src="$REPO"
else
	src="$work/src"
	mkdir -p "$src"
	git archive --format=tar HEAD | tar -x -C "$src"
fi

# 2. Hugo 构建。缓存与生成的资源放进这次构建自己的临时目录、不写构建锁，几个构建（例如并行迁移页面时）可以同时进行。
#    --minify 压缩 HTML、CSS 与脚本；两个 print 选项把重复的产物路径与缺失的界面文字报成警告，警告即错误。
rm -rf -- "$out"
log="$work/hugo.log"
if ! HUGO_RESOURCEDIR="$work/resources" "$REPO/scripts/hugo" --source "$src" --destination "$out" \
	--cacheDir "$work/cache" --noBuildLock --minify --printPathWarnings --printI18nWarnings --logLevel warn >"$log" 2>&1; then
	cat "$log" >&2
	die "Hugo 构建失败"
fi
if grep -E '^(WARN|ERROR)' "$log" >/dev/null; then
	grep -E '^(WARN|ERROR)' "$log" >&2
	die "Hugo 有警告（构建把警告视为错误）"
fi

# 3. desktop2.json 原样发布在根目录，供桌面版 release.sh 校验与外部读取（4.7）。
cp "$src/desktop2.json" "$out/desktop2.json"

# 4. security.txt：联系方式，Expires 自动取构建时起约一年，不需要人记着更新（4.10）。
mkdir -p "$out/.well-known"
expires="$(date -u -v+360d +%Y-%m-%dT00:00:00Z 2>/dev/null || date -u -d '+360 days' +%Y-%m-%dT00:00:00Z)"
cat >"$out/.well-known/security.txt" <<EOT
Contact: mailto:writer@drakeet.com
Expires: $expires
Preferred-Languages: zh, en
Canonical: https://writer.drakeet.com/.well-known/security.txt
EOT

# 5. 检查：期望产物清单、站内链接与锚点。
if ((run_checks)); then
	check_args=("$out" --expected "$REPO/ops/expected-files.txt")
	((update_expected)) && check_args+=(--update-expected)
	python3 -I "$REPO/scripts/check.py" "${check_args[@]}"
fi

# 6. 预压缩文本文件：Caddy 的 precompressed 优先发送这两种文件，2 Mbps 下 HTML 用 brotli 比 gzip 再小约 20%。
#    放在检查之后，检查只看真正的产物。1 KiB 以下的文件压缩后反而可能更大，不处理；Apple 关联域名文件也在其中。
have_brotli=0
command -v brotli >/dev/null 2>&1 && have_brotli=1
((have_brotli)) || echo "build: 没有找到 brotli，只生成 gzip 预压缩" >&2
while IFS= read -r -d '' file; do
	gzip -9 -n -k -f "$file"
	((have_brotli)) && brotli -q 11 -k -f "$file"
done < <(find "$out" -type f -size +1k \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.json' -o -name '*.xml' -o -name '*.txt' -o -name '*.svg' \) -print0)

echo "构建完成：$out"
