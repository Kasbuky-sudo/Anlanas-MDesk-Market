#!/usr/bin/env bash
#
# 校验并构建 apps/ 下的全部 M·Desk 应用到 dist/。
# 用法：bash scripts/build-all.sh
#       MPKPACK=/path/to/mpkpack bash scripts/build-all.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MPKPACK="${MPKPACK:-mpkpack}"
DIST="${DIST:-$ROOT/dist}"

shopt -s nullglob

apps=()
for dir in "$ROOT"/apps/*/; do
    [ -f "${dir}manifest.json" ] && apps+=("$dir")
done

if [ ${#apps[@]} -eq 0 ]; then
    echo "[build] apps/ 下没有可构建的应用（缺少 manifest.json）"
    exit 0
fi

if ! command -v "$MPKPACK" >/dev/null 2>&1; then
    echo "未找到 mpkpack：$MPKPACK" >&2
    echo "请从 https://mdesk.imcq.top/developer 下载并放入 PATH，或用 MPKPACK=/path/to/mpkpack 指定。" >&2
    exit 1
fi

mkdir -p "$DIST"
built=0
for dir in "${apps[@]}"; do
    manifest="${dir}manifest.json"
    id="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["id"])' "$manifest")"
    version="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$manifest")"
    out="$DIST/${id}-${version}.mpk"

    echo "[validate] ${id} ${version}"
    "$MPKPACK" validate "$dir"

    echo "[build] ${id} ${version} -> ${out#"$ROOT"/}"
    "$MPKPACK" build "$dir" --output "$out" --force
    "$MPKPACK" validate "$out"

    built=$((built + 1))
done

echo "[build] 完成：${built} 个应用，产物在 ${DIST#"$ROOT"/}/"
