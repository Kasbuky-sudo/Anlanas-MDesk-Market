#!/usr/bin/env bash
#
# 把 dist/*.mpk 导入商店目录 www/MPK（index.json、详情、图标、包）。
# 用法：bash scripts/build-market.sh
#       STORE_DIR=/path/to/MPK bash scripts/build-market.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MPKPACK="${MPKPACK:-mpkpack}"
DIST="${DIST:-$ROOT/dist}"
STORE_DIR="${STORE_DIR:-$ROOT/www/MPK}"

shopt -s nullglob
packages=("$DIST"/*.mpk)
if [ ${#packages[@]} -eq 0 ]; then
    echo "dist/ 下没有 .mpk，请先运行 bash scripts/build-all.sh" >&2
    exit 1
fi

if ! command -v "$MPKPACK" >/dev/null 2>&1; then
    echo "未找到 mpkpack：$MPKPACK" >&2
    echo "请从 https://mdesk.imcq.top/developer 下载并放入 PATH，或用 MPKPACK=/path/to/mpkpack 指定。" >&2
    exit 1
fi

mkdir -p "$STORE_DIR"
for mpk in "${packages[@]}"; do
    echo "[store] $(basename "$mpk")"
    # 同版本重复导入必须带 --force，否则会报“已存在”。
    "$MPKPACK" store "$mpk" --store-dir "$STORE_DIR" --force
done

echo "[store] 完成：${#packages[@]} 个包，目录 ${STORE_DIR}"
echo "[store] 提示：商店目录有 10 分钟缓存，客户端不会立即看到更新。"
