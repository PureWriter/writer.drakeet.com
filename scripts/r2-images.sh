#!/usr/bin/env bash
# R2 上旧图片的副本（docs/egress-offloading.md 6.2、6.3；日常操作见 docs/operations.md 5.3）：
#   scripts/r2-images.sh upload    核对本地 static/ 的字节与清单一致之后，把清单里的文件传到 kuromi 存储桶的 writer/ 下
#   scripts/r2-images.sh verify    核对 R2 上的副本，三项全部通过才以 0 退出
#
# 为什么有这份副本：Android 新版本加载本站 /images/ 下的稿纸与 Pro 图片时先试 Cloudflare（kuromi.drakeet.cn/writer/…），
# 失败再回到本站，以此分走本站的出口。对象键是 writer/ 加 ops/images.sha256 里的路径，例如 images/papers/0.jpg 对应
# writer/images/papers/0.jpg。这份清单是唯一正本：只传、只认清单里的文件。
#
# upload：
#   1. 按清单逐个核对 static/ 下文件的 sha256，任何一个不符都不上传；
#   2. 列出 writer/ 前缀，必须为空。不为空就列出已有的键并停下：本脚本只做首次上传，不覆盖已有对象，重传另行处理；
#   3. 逐个 put-object，带上与本站 Caddy 相同的 Content-Type 与 Cache-Control。
# verify（三项全部通过才算完成）：
#   1. 列出 writer/ 前缀的键，与清单逐一对应，不多不少；
#   2. 经公开地址逐个取回（不跟随跳转、不带 Accept-Encoding），sha256 与清单一致；
#   3. 同一响应的状态码是 200，Content-Type 与 Cache-Control 是上传时设的值。
#   R2 上没有的键不经公开地址去取，只报「不存在」：按 Cloudflare 的默认缓存规则，图片地址的 404 会在边缘缓存几分钟，
#   上传前取过一次，上传后紧接着核对就可能读到缓存的 404。
#
# 只写 writer/ 下的对象，脚本里没有任何删除操作：桶里其他对象属于桌面版与 OCAT 的发版流程（docs/egress-offloading.md 2.4）。
# R2 凭据只经 aws CLI 的 profile 使用（Drakeet 的 Mac 上已配好），脚本不读取也不打印。
set -euo pipefail

cd "$(dirname "$0")/.."

# 存储桶、profile、endpoint 与公开域名同桌面版仓库 scripts/release-common.sh 的同名配置，改动时两边一起改。
readonly R2_BUCKET=kuromi
readonly R2_PROFILE=cloudflare-r2
readonly R2_ENDPOINT=https://7db3551fea48f24010be8649a8ecf240.r2.cloudflarestorage.com
readonly R2_PUBLIC_BASE_URL=https://kuromi.drakeet.cn
readonly KEY_PREFIX=writer/
readonly MANIFEST=ops/images.sha256
# 与本站 /images/ 相同（caddy/site.caddy），一周。字节永不改变，本可以给一年加 immutable；取一周是为了万一传错，
# Cloudflare 边缘最多一周就自动更正，不必依赖清缓存（docs/egress-offloading.md 6.2）。
readonly CACHE_CONTROL="public, max-age=604800"

die() {
	echo "r2-images: $*" >&2
	exit 1
}

# verify 把取回的响应放在临时目录里，退出时（包括出错与中断）删掉。变量放在全局：EXIT 时函数里的局部变量已经不在了。
work=""
cleanup() {
	if [[ -n "$work" ]]; then
		rm -rf -- "$work"
	fi
}
trap cleanup EXIT

aws_r2() {
	aws --profile "$R2_PROFILE" --endpoint-url "$R2_ENDPOINT" "$@"
}

# 按扩展名给出 Content-Type，与本站 Caddy 返回的一致。清单里出现别的扩展名时报错，先确认本站给的类型再补进来。
content_type_for() {
	case "$1" in
		*.jpg) echo image/jpeg ;;
		*.png) echo image/png ;;
		*.webp) echo image/webp ;;
		*.svg) echo image/svg+xml ;;
		*) die "不认识 $1 的扩展名：先用 curl -sI https://writer.drakeet.com/$1 查本站给的 Content-Type，再补进 content_type_for" ;;
	esac
}

# 读入清单（格式与 scripts/check.py 相同）：每行「sha256  路径」，以 # 开头的行与空行是注释。
# 路径只允许字母、数字与「._-/」，这样对象键与公开地址都不必转义；同时排除「..」一类越出 images/ 的写法。
paths=()
sums=()
types=()
load_manifest() {
	local pattern='^([0-9a-f]{64})  (images/[A-Za-z0-9._/-]+)$'
	local line_no=0 line sum path content_type duplicates
	[[ -f "$MANIFEST" ]] || die "找不到清单 $MANIFEST"
	while IFS= read -r line || [[ -n "$line" ]]; do
		line_no=$((line_no + 1))
		if [[ -z "${line//[[:space:]]/}" || "$line" == "#"* ]]; then
			continue
		fi
		[[ "$line" =~ $pattern ]] || die "$MANIFEST:$line_no 应写成「sha256  images/…」，路径只含字母、数字与 ._-/：$line"
		sum="${BASH_REMATCH[1]}"
		path="${BASH_REMATCH[2]}"
		if [[ "$path" == *..* || "$path" == *//* || "$path" == */ ]]; then
			die "$MANIFEST:$line_no 的路径不规范：$path"
		fi
		content_type="$(content_type_for "$path")" || exit 1
		paths+=("$path")
		sums+=("$sum")
		types+=("$content_type")
	done <"$MANIFEST"
	((${#paths[@]} > 0)) || die "$MANIFEST 里没有任何文件"
	duplicates="$(printf '%s\n' "${paths[@]}" | sort | uniq -d)"
	[[ -z "$duplicates" ]] || die "$MANIFEST 里有重复的路径：$duplicates"
}

# 列出 writer/ 前缀下的全部键，每行一个。aws CLI v2 会自动翻页；前缀下没有对象时 --query 输出 None，这里滤掉。
# 只吞掉 grep 的「无匹配」，aws 本身失败仍让调用方中止（与 release-common.sh 的 r2_list 相同）。
list_keys() {
	aws_r2 s3api list-objects-v2 --bucket "$R2_BUCKET" --prefix "$KEY_PREFIX" --query 'Contents[].[Key]' --output text |
		{ grep -v '^None$' || true; }
}

# 上传前核对本地字节：构建时 scripts/check.py 按同一份清单核对过 static/images/，但工作区可能有未提交的改动，
# 所以上传前再逐个核对一次，有一个不符就一个都不传。
check_local() {
	local i file actual problems=0 total=0
	for i in "${!paths[@]}"; do
		file="static/${paths[$i]}"
		if [[ ! -f "$file" ]]; then
			echo "缺少 $file" >&2
			problems=$((problems + 1))
			continue
		fi
		actual="$(shasum -a 256 "$file" | awk '{print $1}')"
		if [[ "$actual" != "${sums[$i]}" ]]; then
			echo "$file 的 sha256 是 $actual，清单里是 ${sums[$i]}" >&2
			problems=$((problems + 1))
		fi
		total=$((total + $(wc -c <"$file")))
	done
	((problems == 0)) || die "本地 static/ 有 $problems 个文件与 $MANIFEST 不符，没有上传任何文件"
	echo "本地 static/ 下 ${#paths[@]} 个文件与清单一致，共 $total 字节"
}

upload() {
	local existing count i key
	check_local
	existing="$(list_keys)" || die "列出 $R2_BUCKET 存储桶的 $KEY_PREFIX 前缀失败（aws 的报错见上，profile $R2_PROFILE）"
	if [[ -n "$existing" ]]; then
		count="$(wc -l <<<"$existing" | tr -d ' ')"
		head -n 20 <<<"$existing" >&2
		die "$KEY_PREFIX 前缀下已有 $count 个对象（上面列出至多 20 个），没有上传任何文件。本脚本只做首次上传、不覆盖已有对象：先运行 verify 看清现状，再决定怎么处理"
	fi
	for i in "${!paths[@]}"; do
		key="$KEY_PREFIX${paths[$i]}"
		# 用 s3api put-object 而不是 s3 cp：后者默认附带的校验算法与 R2 不兼容（同 release-common.sh 的 r2_put）。
		if ! aws_r2 s3api put-object --bucket "$R2_BUCKET" --key "$key" --body "static/${paths[$i]}" \
			--content-type "${types[$i]}" --cache-control "$CACHE_CONTROL" >/dev/null; then
			die "上传 $key 失败（aws 的报错见上）。已经传上去的 $i 个对象不会撤回，再运行 upload 会因前缀不为空而拒绝；先运行 verify 看清现状，再决定怎么处理"
		fi
		echo "已上传 $key（$((i + 1))/${#paths[@]}）"
	done
	echo "上传完成：${#paths[@]} 个对象。接着运行 scripts/r2-images.sh verify 核对"
}

# 取响应头文件里某个头的值（名字不分大小写），同名头出现多次时逐行输出，与期望值比较时自然不等。
# 遇到状态行就清空已收集的值，所以 curl 重试时留下的多段响应头只取最后一段。
header_value() {
	tr -d '\r' <"$2" | awk -v name="$1" '
		/^HTTP\// { count = 0; next }
		{
			colon = index($0, ":")
			if (colon == 0 || tolower(substr($0, 1, colon - 1)) != name) next
			value = substr($0, colon + 1)
			sub(/^[ \t]+/, "", value)
			sub(/[ \t]+$/, "", value)
			values[++count] = value
		}
		END { for (i = 1; i <= count; i++) print values[i] }
	'
}

verify() {
	local listed expected key url status actual content_type cache_control i line joined
	local key_missing=0 key_extra=0 hash_ok=0 hash_bad=0 head_ok=0 head_bad=0 not_fetched=0
	local file_problems=()
	work="$(mktemp -d "${TMPDIR:-/tmp}/writer-r2-images.XXXXXX")"

	listed="$(list_keys)" || die "列出 $R2_BUCKET 存储桶的 $KEY_PREFIX 前缀失败（aws 的报错见上，profile $R2_PROFILE）"
	expected="$(for i in "${!paths[@]}"; do echo "$KEY_PREFIX${paths[$i]}"; done)"

	# 第 1 项：多出来的键（在 R2 上、不在清单里）。缺少的键在下面逐个文件时报出。
	while IFS= read -r key; do
		[[ -n "$key" ]] || continue
		if ! grep -Fxq -- "$key" <<<"$expected"; then
			echo "多余  $key：不在 $MANIFEST 里"
			key_extra=$((key_extra + 1))
		fi
	done <<<"$listed"

	for i in "${!paths[@]}"; do
		key="$KEY_PREFIX${paths[$i]}"
		if ! grep -Fxq -- "$key" <<<"$listed"; then
			echo "不存在  $key：R2 上没有这个键，未经公开地址取回"
			key_missing=$((key_missing + 1))
			not_fetched=$((not_fetched + 1))
			continue
		fi

		url="$R2_PUBLIC_BASE_URL/$key"
		file_problems=()
		# -q 必须是第一个参数：不读 ~/.curlrc，免得那里的 --location、--compressed 之类改变这里的请求。
		# 不加 -L：公开地址应当直接返回 200，跳转本身就算不通过。不加 --compressed：curl 默认不发 Accept-Encoding，
		# Cloudflare 因此按原样返回，取回的就是对象的原字节。
		if ! status="$(curl -q -sS --connect-timeout 15 --max-time 120 --retry 2 --retry-delay 2 \
			-D "$work/headers" -o "$work/body" -w '%{http_code}' "$url")"; then
			echo "不通过  $key：经 $url 取回失败（curl 的报错见上）"
			not_fetched=$((not_fetched + 1))
			continue
		fi

		# 第 2 项：字节。非 200 的响应体不是这个文件，不算 sha256 的比较，只记一笔「未取得文件」。
		if [[ "$status" != 200 ]]; then
			file_problems+=("未取得文件，无法核对 sha256")
			hash_bad=$((hash_bad + 1))
		else
			actual="$(shasum -a 256 "$work/body" | awk '{print $1}')"
			if [[ "$actual" == "${sums[$i]}" ]]; then
				hash_ok=$((hash_ok + 1))
			else
				file_problems+=("sha256 是 $actual，清单里是 ${sums[$i]}")
				hash_bad=$((hash_bad + 1))
			fi
		fi

		# 第 3 项：同一响应的状态码与两个头。
		content_type="$(header_value content-type "$work/headers")"
		cache_control="$(header_value cache-control "$work/headers")"
		line=""
		[[ "$status" == 200 ]] || line+="状态码 $status；"
		[[ "$content_type" == "${types[$i]}" ]] || line+="Content-Type 是「$content_type」，应为「${types[$i]}」；"
		[[ "$cache_control" == "$CACHE_CONTROL" ]] || line+="Cache-Control 是「$cache_control」，应为「$CACHE_CONTROL」；"
		if [[ -z "$line" ]]; then
			head_ok=$((head_ok + 1))
		else
			file_problems+=("${line%；}")
			head_bad=$((head_bad + 1))
		fi

		if ((${#file_problems[@]} == 0)); then
			echo "通过  $key"
		else
			joined="$(printf '%s；' "${file_problems[@]}")"
			echo "不通过  $key：${joined%；}"
		fi
	done

	local total=${#paths[@]} listed_count
	listed_count="$(grep -c . <<<"$listed" || true)"
	echo
	if ((key_missing == 0 && key_extra == 0)); then
		echo "第 1 项 键与清单逐一对应：通过（R2 上 $listed_count 个键，清单 $total 个）"
	else
		echo "第 1 项 键与清单逐一对应：不通过（R2 上 $listed_count 个键，清单 $total 个；缺少 $key_missing 个，多余 $key_extra 个）"
	fi
	if ((hash_ok == total)); then
		echo "第 2 项 公开地址取回的 sha256：通过（$hash_ok 个一致）"
	else
		echo "第 2 项 公开地址取回的 sha256：不通过（一致 $hash_ok 个，不符 $hash_bad 个，未取回 $not_fetched 个）"
	fi
	if ((head_ok == total)); then
		echo "第 3 项 状态码 200、Content-Type、Cache-Control：通过（$head_ok 个）"
	else
		echo "第 3 项 状态码 200、Content-Type、Cache-Control：不通过（正确 $head_ok 个，不对 $head_bad 个，未取回 $not_fetched 个）"
	fi

	if ((key_missing || key_extra || hash_ok != total || head_ok != total)); then
		die "核对不通过。字节或头不对时先看对象本身（aws s3api head-object），重传与清缓存的注意事项见 docs/operations.md 5.3"
	fi
	echo "核对通过：$total 个对象与 $MANIFEST 一致"
}

usage="用法：scripts/r2-images.sh upload|verify"
(($# == 1)) || die "$usage"
case "$1" in
	upload | verify) ;;
	*) die "$usage" ;;
esac
load_manifest
"$1"
