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

## 许可

仓库脚手架与 README 使用 Apache-2.0；`packages/` 内各应用仍受其上游许可证约束。

## LG 本机源部署

LG 宿主机直连 GitHub raw 会被重置（GFW），而 M·Desk 拉源是宿主机行为、走不了桌面端的梯子。因此 LG 上的 M·Desk 使用本机源：

```text
http://127.0.0.1:18081/
```

- 源文件部署在 LG 的 `/opt/mdesk-market/`，由 systemd 服务 `mdesk-market.service` 以 loopback HTTP 提供（`systemctl status mdesk-market`）；
- GitHub 仓库仍是源头：更新应用后 `git push`，再把仓库打成 tar 同步到 LG 的 `/opt/mdesk-market/` 即可，无需重启服务；
- 临时同步：桌面端 `python3 -m http.server 18900 --directory /tmp`（先打包 tar 到 /tmp），LG 上 `curl http://192.168.31.32:18900/market.tar.gz | tar -xz -C /opt/mdesk-market`。
