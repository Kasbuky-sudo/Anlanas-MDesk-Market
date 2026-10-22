# fnOS Apps

飞牛 fnOS 原生应用移植集合（非 Docker）。每个应用一个独立目录、独立构建、独立发布；仓库只保留适配代码、打包脚本、元数据和文档，不提交官方安装包、运行时或构建产物。

## 应用

| 应用 | 目录 | 架构 | 状态 | 说明 |
| --- | --- | --- | --- | --- |
| 暂无 | — | — | — | 后续应用按 [`docs/REPO-STANDARD.md`](docs/REPO-STANDARD.md) 加入 |

应用索引与每个应用的简介见 [`apps/README.md`](apps/README.md)。

## 仓库约定（摘要）

- **一个应用一个目录**：`apps/<app-id>/`，应用之间不共享运行时和构建产物；
- 每个应用自带 `README.md`，写清上游来源、安装方式、构建步骤、已知限制和免责声明；
- 每个应用的 fnOS 包布局放在 `apps/<app-id>/packaging/fnOS/`（`manifest`、`cmd/`、`config/`、`ui/`、`wizard/`、`scripts/`）；
- **不入库**：官方 deb/rpm/AppImage、解包后的运行时、`node_modules/`、`dist/`、`.build-staging/`、日志与本地数据；
- **发布资产**使用 `<app-id>-<version>-<arch>.fpk`，x86 与 arm64 分开命名，校验 sha256 后再上传；
- 第三方应用需在应用 README 中注明非官方移植、商标与版权归属，并在权利人要求时移除相关资源。

完整规范见 [`docs/REPO-STANDARD.md`](docs/REPO-STANDARD.md)，新应用上线前的验收清单见 [`docs/ACCEPTANCE.md`](docs/ACCEPTANCE.md)。

## 新建应用

```bash
mkdir -p apps/<app-id>/{packaging/fnOS/{cmd,config,ui,wizard,scripts},docs}
# 按 docs/REPO-STANDARD.md 放置 manifest、生命周期脚本和构建脚本
```

## 许可

仓库脚手架、共享文档与原创适配/打包代码使用 [Apache-2.0](LICENSE)。`apps/` 下的第三方应用与组件仍受其各自许可证约束，详见各应用目录内的说明。
