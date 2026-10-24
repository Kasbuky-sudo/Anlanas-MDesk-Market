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

## 宿主机访问说明

LG 宿主机直连 GitHub raw 会被重置（GFW），M·Desk 拉源又是宿主机行为、走不了桌面端的梯子。目前由 Fluxor（mihomo TUN）在宿主机上代理，GitHub raw 源可正常拉取。

备用方案保留在 LG 上：`/opt/mdesk-market/` + systemd `mdesk-market.service` 提供 `http://127.0.0.1:18081/`（loopback HTTP 允许）。节点不稳时可临时把订阅切到该地址；同步方式为桌面端打包 tar 后经局域网传到 LG 解压，无需重启服务。
