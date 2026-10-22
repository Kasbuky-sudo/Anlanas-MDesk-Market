# 仓库规范

本仓库用于存放多个飞牛 fnOS 原生应用。规范的目标是：新增应用时目录一致、构建可复现、发布可核对、第三方合规边界清楚。

## 1. 目录结构

```text
apps/<app-id>/
├── README.md                    # 必需：上游来源、安装、构建、限制、免责声明
├── LICENSE                      # 可选：与仓库根许可证不同时提供
├── adapter/                     # 可选：Web / 协议适配层（按应用需要）
├── packaging/fnOS/
│   ├── manifest                 # fnOS 应用元信息
│   ├── cmd/                     # 生命周期脚本
│   │   ├── main
│   │   ├── install_init
│   │   ├── install_callback
│   │   ├── upgrade_init
│   │   ├── upgrade_callback
│   │   ├── uninstall_init
│   │   ├── uninstall_callback
│   │   └── config_callback
│   ├── config/
│   │   ├── privilege            # 运行用户 / 用户组
│   │   └── resource             # 共享目录声明（可选）
│   ├── ui/
│   │   ├── config               # 桌面入口
│   │   └── images/              # 图标
│   ├── wizard/                  # 安装 / 设置向导（可选）
│   │   ├── install
│   │   └── config
│   └── scripts/
│       ├── build.sh             # x86_64 构建
│       └── build-arm64.sh       # 可选：arm64 构建
└── docs/                        # 可选：应用级说明、移植清单
```

构建产物只落在 `packaging/fnOS/dist/` 和 `packaging/fnOS/.build-staging/`，这两个目录不入库。

## 2. 命名

- `app-id`：小写字母、数字、连字符，例如 `my-app`；必须与 `manifest` 的 `appname` 一致。
- 包版本：优先沿用上游版本；需要重新打包时追加第四段，例如上游 `1.2.3` → `1.2.3.1`。
- fpk 资产：`<app-id>-<version>-x86.fpk`、`<app-id>-<version>-arm64.fpk`。
- Git 标签：`<app-id>-v<version>`；Release 标题与标签一致。
- 分支：`main`。

## 3. manifest

至少确认以下字段：

| 字段 | 约定 |
| --- | --- |
| `appname` | 与目录名、资产前缀一致 |
| `version` | 见上节版本规则 |
| `display_name` / `desc` | 中文显示名与一句话说明 |
| `platform` | x86 包写 `x86`；arm64 包写 `arm`；**不要用 `all`**，除非单个包确实同时包含两套原生模块 |
| `source` | `thirdparty` |
| `developer` / `maintainer` / `distributor` | 上游与移植者信息、URL |
| `license` | 第三方专有应用写 `Proprietary`，并在应用 README 说明 |
| `desktop_uidir` / `desktop_applaunchname` | 指向 `ui/config` 中的入口 |
| `service_port` | 固定端口；入口 `ui/config` 必须使用同一端口 |
| `install_dep_apps` | 例如 `nodejs_v22`，不要在包内重复携带运行时 |
| `ctl_stop` / `checkport` | 一般为 `true` |

## 4. 运行时与原生模块

- 复用飞牛应用中心的运行时（如 Node.js v22），包内不重复打包 Node。
- 原生模块的 ABI 必须匹配目标运行时：Node 22 是 `NODE_MODULE_VERSION 127`；Electron 的 `136` 不能直接用。
- 构建脚本必须用 `file` 检查 `.node` 和可执行文件：
  - x86 包拒绝 `aarch64`、`Mach-O`、`PE32`；
  - arm64 包拒绝 `x86-64`、`Mach-O`、`PE32`，并要求关键二进制为 `ARM aarch64`。
- 依赖 Electron 布局的 daemon，用 `app.asar.unpacked` 符号链接补齐 `resourcesPath`。

## 5. 生命周期脚本

- `#!/bin/bash` + `set -u`；使用 fnOS 注入的 `TRIM_*` 变量，不写死 `/vol1`。
- 查找依赖时覆盖 `/var/apps/<dep>/...` 与 `/vol*/@appcenter/<dep>/...`。
- 端口判断只认 `LISTEN (0A)`，`TIME_WAIT` 不算监听。
- 进程匹配必须限定应用自己的 `adapter/` 或可执行路径，避免误杀生命周期脚本。
- `fnpack` 会把 `app.tgz` 内权限拍平成 `0666`；`install_callback` / `upgrade_callback` 必须补回可执行位。
- 令牌、密钥写入 `TRIM_PKGVAR/etc/`，权限 `0600`，不要进入 git。
- 应用数据、工作区 `chown` 给包运行用户；共享目录通过 `config/resource` 声明，并从 `TRIM_DATA_SHARE_PATHS` 解析。

## 6. 发布

1. 构建 fpk，确认架构与 manifest 的 `platform` 一致；
2. 记录 `sha256sum` 与文件大小；
3. 创建 GitHub Release（标签见第 2 节），上传 x86 / arm64 资产；
4. Release 说明包含：上游版本、适配层变更、已知限制、安装前置依赖；
5. 更新 FnDepot 索引时，同一版本下同时提供 `packages.x86` 与 `packages.arm`（`platform: ["x86","arm"]`）。

## 7. 第三方与合规

- 仓库**不分发**官方安装包（deb/rpm/AppImage）、解包后的运行时、专有二进制。
- 应用 README 必须写明：非官方移植、上游名称与版权/商标归属、适用许可证、权利人可要求移除的资源。
- 图标等品牌资源仅用于标识对应应用，不声明版权。
- 代码和文档中不要出现内网 IP、访问令牌、Cookie、账号信息。

## 8. 应用 README 模板

```markdown
# <应用名> · 飞牛 fnOS 原生版

一句话说明这个应用在 NAS 上做什么。

> 非官方移植，与 <上游公司> 无关。本目录只包含适配层与打包脚本，
> 不分发 <应用名> 本体或官方安装包。

## 安装
## 访问令牌 / 首次配置
## 工作区与数据
## 运行架构
## 与桌面版的差异
## 构建
## 已知限制
## 许可与商标
```
