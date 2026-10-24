# Anlanas's MDesk Market

M·Desk 三方订阅源（纯静态目录）。

## 源地址

添加到 M·Desk：**应用中心 → 三方订阅源 → 管理订阅**。

```text
https://kasbuky-sudo.github.io/Anlanas-MDesk-Market/
```

用 GitHub Pages 而不是 `raw.githubusercontent.com`：raw 给 `.json` 返回 `text/plain`，M·Desk 的详情接口只接受 `application/json`，会导致详情和从源安装报 502。

## 收录

| 应用 | packageId | 版本 | 架构 | 打开方式 |
|---|---|---|---|---|
| 米游签 | `mdesk.miyouqian` | 1.0.6 | amd64 / arm64 | 桌面窗口内（`in-app`） |
| Trae2api CN | `mdesk.trae2api` | 1.0.10 | amd64 / arm64 | 浏览器新标签页（`new-tab`） |

两个应用都自带运行时和依赖，不依赖 M·Desk 应用中心提供 Node/Python 等依赖包；均为 native + socket，不占用宿主机端口。Trae2api 的网页授权和授权助手脚本下载需要完整浏览器，因此声明 `new-tab`。

## 许可

仓库脚手架与 README 使用 Apache-2.0；`packages/` 内各应用仍受其上游许可证约束。

## 说明

M·Desk 2.7.114 及更早版本的客户端可能不接受 manifest 中的 `store` 段；本仓库的包按 2026-10-24 版开发者标准构建，建议使用较新的 M·Desk 客户端。
