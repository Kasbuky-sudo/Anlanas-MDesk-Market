# Anlanas's MDesk Market

M·Desk 三方订阅源（纯静态目录）。

## 源地址

添加到 M·Desk：**应用中心 → 三方订阅源 → 管理订阅**。

```text
https://raw.githubusercontent.com/Kasbuky-sudo/Anlanas-MDesk-Market/main/
```

## 收录

| 应用 | packageId | 版本 | 架构 | 打开方式 |
|---|---|---|---|---|
| 米游签 | `mdesk.miyouqian` | 1.0.6 | amd64 / arm64 | 桌面窗口内（`in-app`） |
| Trae2api CN | `mdesk.trae2api` | 1.0.10 | amd64 / arm64 | 浏览器新标签页（`new-tab`） |

两个应用都自带运行时和依赖，不依赖 M·Desk 应用中心提供 Node/Python 等依赖包；均为 native + socket，不占用宿主机端口。Trae2api 的网页授权和授权助手脚本下载需要完整浏览器，因此声明 `new-tab`。

## 许可

仓库脚手架与 README 使用 Apache-2.0；`packages/` 内各应用仍受其上游许可证约束。

## 宿主机访问说明（LG）

M·Desk 拉源是宿主机行为。LG 宿主机有两层问题：

1. 直连 GitHub raw 会被 GFW 重置，目前靠 Fluxor（mihomo TUN）代理；
2. GitHub raw 给 `.json` 返回的 `Content-Type` 是 `text/plain`，而 M·Desk 的详情接口要求 `application/json`，会报 `unexpected JSON content type "text/plain"`。结果是列表能刷新，但应用详情和从源安装会返回 502。

因此 LG 上的 M·Desk 订阅使用本机镜像（返回 `application/json`）：

```text
http://127.0.0.1:18081/
```

- 镜像目录 `/opt/mdesk-market/`，由 systemd 服务 `mdesk-market.service` 以 loopback HTTP 提供，已 enable（`systemctl status mdesk-market`）；
- 镜像内容来自本仓库：`git push` 后把仓库打成 tar，经局域网传到宿主机的 `/opt/mdesk-market/` 解压，无需重启服务；
- GitHub raw 地址保留给能直连、且客户端不校验 JSON MIME 的环境。以后如果给仓库启用 GitHub Pages（Pages 会返回 `application/json`），可以直接把订阅换成 Pages 地址。
