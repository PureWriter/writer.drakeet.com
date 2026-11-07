#!/usr/bin/env bash
# 重建期间用：把新站的每个页面与旧站的同一页面逐页比对正文与锚点（docs/rebuild.md 第九节 B「逐页文本比对」）。
#   scripts/compare-migration.sh                 先从工作区构建一份产物，再逐页比对
#   scripts/compare-migration.sh --out <目录>    比对已有的产物目录，不再构建
#
# 旧页一律取自旧站最后一个内容提交 069a297（rebuild 分支就是从它分出来的，一直在本仓库的历史里），
# 第 C 步之后照样可用。全部一致时退出码为 0；有差异时列出差异、以 1 退出。
# 两类差异是预期的，只列出、不算失败，复核时逐条看：
#   - 下载页：旧页的版本信息由脚本在运行时填入，新页在构建时写入；去掉了不再成立的两句提示；
#   - 英文 Android 隐私政策：「Links」一节里显示成网址的链接文字换成了新地址 /en/（第 D 步同时更新 OAuth 同意屏幕的登记）。
set -euo pipefail

cd "$(dirname "$0")/.."
readonly REPO="$PWD"
readonly OLD_COMMIT=069a297

out=""
if [[ "${1:-}" == --out ]]; then
	out="$2"
fi

work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$work/old"
git archive "$OLD_COMMIT" | tar -x -C "$work/old"
if [[ -z "$out" ]]; then
	out="$work/site"
	scripts/build.sh --worktree --no-check --out "$out" >/dev/null
fi

# 旧页｜旧页里的区域（空则用默认）｜新页｜是否允许差异（known 表示预期有差异）
pages=(
	"index.html|article[data-locale=zh-Hans]|zh-hans/index.html|"
	"index.html|article[data-locale=zh-Hant]|zh-hant/index.html|"
	"index.html|article[data-locale=zh-HK]|zh-hk/index.html|"
	"index.html|article[data-locale=en]|en/index.html|"
	"index.html|article[data-locale=ja]|ja/index.html|"
	"desktop.html|article[data-locale=zh-Hans]|zh-hans/desktop/index.html|known"
	"desktop.html|article[data-locale=zh-Hant]|zh-hant/desktop/index.html|known"
	"desktop.html|article[data-locale=zh-HK]|zh-hk/desktop/index.html|known"
	"desktop.html|article[data-locale=en]|en/desktop/index.html|known"
	"desktop.html|article[data-locale=ja]|ja/desktop/index.html|known"
	"desktop.html|article[data-locale=ru]|ru/desktop/index.html|known"
	"ios/privacy.html|article[data-locale=zh-Hans]|zh-hans/ios/privacy/index.html|"
	"ios/privacy.html|article[data-locale=zh-Hant]|zh-hant/ios/privacy/index.html|"
	"ios/privacy.html|article[data-locale=zh-HK]|zh-hk/ios/privacy/index.html|"
	"ios/privacy.html|article[data-locale=en]|en/ios/privacy/index.html|"
	"ios/privacy.html|article[data-locale=ja]|ja/ios/privacy/index.html|"
	"ios/support.html|article[data-locale=zh-Hans]|zh-hans/ios/support/index.html|"
	"ios/support.html|article[data-locale=zh-Hant]|zh-hant/ios/support/index.html|"
	"ios/support.html|article[data-locale=zh-HK]|zh-hk/ios/support/index.html|"
	"ios/support.html|article[data-locale=en]|en/ios/support/index.html|"
	"ios/support.html|article[data-locale=ja]|ja/ios/support/index.html|"
	"wiki.html||zh-hans/manual/index.html|"
	"wiki_zh.html||zh-hant/manual/index.html|"
	"wiki_en.html||en/manual/index.html|"
	"backups.html||zh-hans/backups/index.html|"
	"backups_zh.html||zh-hant/backups/index.html|"
	"backups_en.html||en/backups/index.html|"
	"markdown.html||zh-hans/markdown/index.html|"
	"protections.html||zh-hans/protections/index.html|"
	"warning.html||zh-hans/genuine/index.html|"
	"privacy.html||zh-hans/android/privacy/index.html|"
	"privacy_en.html||en/android/privacy/index.html|known"
	"d/privacy.html||en/desktop/privacy/index.html|"
	"blog/NewDesktopDevStory.html||en/blog/new-desktop-dev-story/index.html|"
)

failures=0
for entry in "${pages[@]}"; do
	IFS='|' read -r old_file selector new_file allowance <<<"$entry"
	args=("$work/old/$old_file" "$out/$new_file" --ids --skip footer)
	[[ -n "$selector" ]] && args+=(--old-select "$selector")
	if result="$(python3 -I -B scripts/compare-text.py "${args[@]}")"; then
		printf '一致   %-44s %s\n' "/$new_file" "$(head -n 1 <<<"$result")"
	elif [[ "$allowance" == known ]]; then
		printf '预期差 %-44s（见文件开头的说明，逐条复核）\n' "/$new_file"
		sed 's/^/        /' <<<"$result"
	else
		failures=$((failures + 1))
		printf '差异   %-44s\n' "/$new_file"
		sed 's/^/        /' <<<"$result"
	fi
done
if ((failures)); then
	echo "共 $failures 页与旧页不一致" >&2
	exit 1
fi
echo "全部页面的正文与锚点都与旧页一致（下载页的预期差异除外）"
