# Anlanas's MDesk Market

M·Desk 应用市场：按 [M·Desk 开发者标准](https://mdesk.imcq.top/developer) 收录、打包和上架应用。一个应用一个目录，源目录只保留 `manifest.json`、图标、启动脚本与资源；`.mpk` 和商店目录由 `mpkpack` 生成。

> 非 M·Desk 官方市场。各应用的版权归其作者 / 厂商所有；本仓库只做适配、打包与上架，不包含未获授权的专有运行时或官方安装包。

## 工作流

```text
apps/<id>/  ──mpkpack build──>  dist/<id>-<version>.mpk  ──mpkpack store──>  www/MPK/
```

- 源目录：`apps/<id>/manifest.json` + 图标 + 启动脚本 + 资源
- 构建产物：`dist/<id>-<version>.mpk`（不入库）
- 商店目录：`www/MPK/`，含 `index.json`、应用详情、图标和包（由命令生成，不手改）

## 目录

```text
apps/<id>/                  应用源目录（每个 id 一个目录）
├── manifest.json           唯一手写的元数据文件
├── assets/icon.png         图标（PNG / JPEG / WebP / SVG）
├── bin/                    启动脚本与程序（native）
├── config/                 其他资源（可选）
└── wizard/                 安装 / 设置表单（可选）
dist/                       构建出的 .mpk（不入库）
www/MPK/                    商店目录（生成，不入库）
scripts/
├── build-all.sh            校验并构建 apps/ 下的全部应用
└── build-market.sh         把 dist/*.mpk 导入 www/MPK
docs/
├── REPO-STANDARD.md        目录、manifest、多架构、上架规范
└── ACCEPTANCE.md           上架前验收清单
```

## 应用索引

| 应用 | id | 运行时 | 架构 | 状态 |
| --- | --- | --- | --- | --- |
| 暂无 | — | — | — | 后续添加 |

新增应用时同步更新 [`apps/README.md`](apps/README.md)。

## 新增一个应用

```bash
# 1. 生成最小骨架（mpkpack 放在 PATH，或用 MPKPACK=/path/to/mpkpack）
mpkpack init apps/<id> \
  --id mdesk.example.myapp \
  --name "示例应用" \
  --runtime native \
  --listen port

# 2. 放图标、启动脚本和资源，补全 manifest.json
#    上架本市场需要 store 段：category / author / developer

# 3. 校验 + 构建 + 生成商店目录
bash scripts/build-all.sh
bash scripts/build-market.sh
```

`mpkpack` 从开发者文档页下载，`chmod +x` 后放进 `PATH` 即可；脚本也接受 `MPKPACK=/path/to/mpkpack`。

## 商店目录

`bash scripts/build-market.sh` 会在 `www/MPK/` 生成：

```text
www/MPK/
├── index.json                      商店目录
├── <id>.json                       应用详情（额外含 package 段）
├── icons/<id>.png                  从包里解出的图标
└── packages/<id>-<version>.mpk     应用包
```

- `index.json` 的条目**不含包地址**；详情文件额外包含 `package.path`、`package.sha256`、`package.size`；
- `sha256` 与 `size` 由 `mpkpack store` 自动计算，不要手写；
- 商店目录有 **10 分钟缓存**，上架后不会立刻可见；
- 同版本重复导入需要 `--force`，脚本已默认带上。

把 `www/MPK/` 部署到静态站点即可作为市场源。本地预览：

```bash
python3 -m http.server 8000 --directory www
# 商店目录：http://127.0.0.1:8000/MPK/
```

## 规范

- 完整目录与 manifest 规范：[`docs/REPO-STANDARD.md`](docs/REPO-STANDARD.md)
- 上架前逐项验收：[`docs/ACCEPTANCE.md`](docs/ACCEPTANCE.md)

## 许可

仓库脚手架、共享文档与原创打包脚本使用 [Apache-2.0](LICENSE)。`apps/` 下的应用与第三方组件仍受其各自许可证约束，详见各应用目录内的说明。
