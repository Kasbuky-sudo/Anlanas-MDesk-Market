# Anlanas's MDesk Market

M·Desk 三方订阅源（纯静态目录）。

## 源地址

添加到 M·Desk：**应用中心 → 三方订阅源 → 管理订阅**。

```text
https://raw.githubusercontent.com/Kasbuky-sudo/Anlanas-MDesk-Market/main/
```

## 收录

| 应用 | packageId | 版本 | 架构 |
|---|---|---|---|
| 米游签 | `mdesk.miyouqian` | 1.0.5 | amd64 / arm64 |
| Trae2api CN | `mdesk.trae2api` | 1.0.9 | amd64 / arm64 |

两个应用都自带运行时和依赖，不依赖 M·Desk 应用中心提供 Node/Python 等依赖包。

## 目录

```text
index.json              源清单（mpkpack store 生成）
<packageId>.json         应用详情（含 package.sha256 / size）
icons/                   图标
packages/                .mpk 安装包
```

`index.json`、详情文件、`icons/`、`packages/` 全部由 `mpkpack store` 生成，**不要手改**。

## 更新

```bash
mpkpack build <source-dir> --output dist/<packageId>-<version>.mpk --force
mpkpack store dist/<packageId>-<version>.mpk --store-dir . --force
```

改完提交并推送，用户在应用中心点一次「刷新」即可看到新版本。

## 许可

仓库脚手架与 README 使用 Apache-2.0；`packages/` 内各应用仍受其上游许可证约束。
