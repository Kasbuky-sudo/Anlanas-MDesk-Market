# Anlanas's MDesk Market

M·Desk 三方订阅源（纯静态目录）。

## 源地址

添加到 M·Desk：**应用中心 → 三方订阅源 → 管理订阅**。

```text
https://mdesk.anlanas.icu/
```

腾讯云 COS 香港地域 + 自定义域名（公有读，免备案，HTTPS）。COS 返回 `application/json`，也没有 GitHub 的 100MB 单文件限制，WorkBuddy 的两个 300MB 安装包放在这里。

备用默认域名：`https://anlanasmdesk-hk-1259122558.cos.ap-hongkong.myqcloud.com/`

GitHub Pages 镜像仍然保留，但只收录两个小应用（大包超过 GitHub 单文件上限）：

```text
https://kasbuky-sudo.github.io/Anlanas-MDesk-Market/
```

## 收录

| 应用 | packageId | 版本 | 架构 | 打开方式 |
|---|---|---|---|---|
| 米游签 | `mdesk.miyouqian` | 1.0.6 | amd64 / arm64 | 桌面窗口内（`in-app`） |
| Trae2api CN | `mdesk.trae2api` | 1.0.11 | amd64 / arm64 | 桌面窗口内（`in-app`） |
| WorkBuddy | `mdesk.workbuddy` | 5.6.3 | arm64 | 桌面窗口内（`in-app`） |
| WorkBuddy | `mdesk.workbuddy.x64` | 5.6.3 | amd64 | 桌面窗口内（`in-app`） |

以上应用都自带运行时和依赖，不依赖 M·Desk 应用中心提供 Node/Python 等依赖包；均为 native + socket，不占用宿主机端口，控制台都在 M·Desk 窗口内打开。WorkBuddy 因为单包文件数超过 mpkpack 的 20000 上限，按架构拆成两个同名条目。

## 许可

仓库脚手架与 README 使用 Apache-2.0；`packages/` 内各应用仍受其上游许可证约束。

## 说明

M·Desk 2.7.114 及更早版本的客户端可能不接受 manifest 中的 `store` 段；本仓库的包按 2026-10-24 版开发者标准构建，建议使用较新的 M·Desk 客户端。
