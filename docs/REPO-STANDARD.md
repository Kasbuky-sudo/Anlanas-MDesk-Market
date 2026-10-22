# 仓库规范

本仓库是 **Anlanas's MDesk Market** 的源码与商店目录。所有应用遵循 M·Desk 官方开发者标准：<https://mdesk.imcq.top/developer>。规范的目的是：新增应用时目录一致、构建可复现、上架信息完整、第三方合规边界清楚。

## 1. 目录结构

```text
apps/<id>/
├── manifest.json               # 必需：唯一手写的元数据文件，必须在源目录根
├── assets/icon.png             # 图标：PNG / JPEG / WebP / SVG
├── bin/                        # native 入口与随包程序
├── config/                     # 其他资源（可选）
├── wizard/                     # 安装 / 设置表单（可选）
│   ├── install.json
│   └── config.json
└── README.md                   # 应用说明、上游来源、许可证、免责声明

dist/                           # mpkpack build 产物（不入库）
www/MPK/                        # mpkpack store 生成的商店目录（不入库）
scripts/                        # 批量校验、构建、上架
docs/                           # 仓库级规范与验收清单
```

- `apps/<id>/` 的目录名必须与 `manifest.json` 的 `id` 一致。
- 源目录里**不要**放符号链接、设备文件、FIFO，`mpkpack` 会直接拒绝。
- 构建产物和商店目录不提交；发布时由脚本重新生成。

## 2. id、版本与资产命名

- `id` 匹配 `^[a-z0-9][a-z0-9._-]{2,63}$`，建议反向域名（如 `mdesk.example.myapp`）。
- `id` 同时是安装目录名、`/apps/<id>/` 路径段和 Compose 项目名的来源，**定下来后不要改**。
- 一个 `id` 在商店里只对应一个条目、一个包文件；不能按架构拆成多个包。
- `version` 使用三段式 SemVer（`1.2.3`）。发新版必须递增，否则商店认不出是更新。
- 构建产物统一命名为 `dist/<id>-<version>.mpk`。

## 3. manifest.json

必须满足：

| 字段 | 约定 |
| --- | --- |
| `schema` | 固定为 `1` |
| `id` | 见上节；与目录名一致 |
| `version` | SemVer，升级时递增 |
| `name` | 显示名称，1–80 字符，可用中文 |
| `runtime` | `native` 或 `docker` |
| `web` | 访问契约，见第 4 节 |
| `description` | 一句话说明，最多 500 字符 |
| `architectures` | 只写实际支持的架构，如 `["amd64","arm64"]`；空数组表示不限制，不要用它“兼容所有” |
| `icon` | 包内相对路径，仅 PNG / JPEG / WebP / SVG |
| `native` / `docker` | 与 `runtime` 对应，二者只能有其一 |
| `wizard` | 可选；`install` / `config` 至少声明一个 |
| `store` | 上架本市场时必需，见第 6 节 |

JSON 写法要求：

- UTF-8，中文直接写；
- 不能有注释、尾随逗号；
- 不能出现未定义字段（`mpkpack` 会报 `unknown field`）；
- 路径一律相对包根，不写绝对路径。

## 4. 运行与访问路线

先选“怎么跑”（`native` / `docker`），再选“怎么访问”（`port` / `socket`）。**默认先用 native + port**。

### native + port

```json
"runtime": "native",
"web": { "listen": "port", "preferredPort": 18080, "openPath": "/", "healthPath": "/healthz" },
"native": {
  "executable": "bin/app",
  "args": ["--listen=0.0.0.0:${MDESK_PORT}", "--data=${MDESK_DATA_DIR}"],
  "workingDir": "."
}
```

- 程序必须能监听 `0.0.0.0` 和动态分配的端口；只支持固定端口的程序不能走这条路。
- `preferredPort` 只是首选，端口冲突时会被改分配。
- 健康检查返回 2xx/3xx 视为正常；401/403 也算服务活着。

### native + socket

只有程序能监听 Unix Socket、承载 HTTP，并正确处理 `/apps/<id>/` 前缀时才用。

```json
"web": { "listen": "socket", "openPath": "/", "healthPath": "/healthz" },
"native": {
  "executable": "bin/app",
  "args": ["--socket=${MDESK_SOCKET}", "--base-path=${MDESK_BASE_PATH}", "--data=${MDESK_DATA_DIR}"]
}
```

Socket 路径不要自己写（如 `/tmp/app.sock`），一律用 `${MDESK_SOCKET}`。代理只按 HTTP 使用，非 HTTP 的 Socket 跑不起来。

### docker + port / socket

- Compose 使用**已发布镜像**，不要现场 `build`；
- 端口映射写 `"${MDESK_PORT}:8080"`，容器端口写死；
- 数据卷写 `"${MDESK_DATA_DIR}:/data"`，否则升级后数据会丢；
- 不要写 `container_name`，多实例会冲突；
- socket 模式同样要求容器内服务处理路径前缀。

### 参数与变量

- `args` 按数组传参，不经过 shell；不要写管道、`$(...)`、反引号。
- 会随环境变化的值用 `${MDESK_*}`；用户填的值用 `${field.<name>}`。
- 两个命名空间严格分离，用户值只展开一次。
- 字段为空时对应环境变量完全不注入，程序里用 `${VAR:-默认值}` 回落。
- 不要自己写死端口、Socket 路径、数据目录或基础路径。

## 5. 文件与权限

- 构建时**只有 `native.executable` 被设为 `0755`**，其余文件一律 `0644`。
- 启动脚本内部调用的其他程序要自己 `chmod +x`，否则会 permission denied。
- `checksums.json` 由构建器生成，不要手改。
- 打包完成后用 `mpkpack validate <包>` 校验，任何报错都要先修。

## 6. 上架信息（store 段）

本市场通过 `mpkpack store` 生成目录，因此每个应用必须写 `store`：

```json
"store": {
  "category": "工具",
  "author": "Anlanas",
  "developer": "开发者署名"
}
```

| 字段 | 必填 | 说明 | 上限 |
| --- | --- | --- | --- |
| `category` | 是 | 商店分组，如 `工具`、`AI`、`媒体` | 160 字 |
| `author` | 是 | 维护者，显示在商店页面 | 160 字 |
| `developer` | 是 | 开发者署名 | 160 字 |
| `introduction` | 否 | 长介绍；留空回退 `description` | 16000 字 |
| `summary` | 否 | 列表摘要；留空回退 `description` | 4000 字 |

- 加了 `store` 段的包在过旧的 M·Desk 上会被拒绝安装，这是预期行为。
- 名称、版本、id、架构、图标、包大小、哈希都由商店从包里读取，不要另写。

## 7. 构建与上架

```bash
# 单个应用
mpkpack validate apps/<id>
mpkpack build apps/<id> --output dist/<id>-<version>.mpk --force
mpkpack validate dist/<id>-<version>.mpk

# 全部应用 + 生成商店目录
bash scripts/build-all.sh
bash scripts/build-market.sh
```

`mpkpack store` 生成：

```text
www/MPK/
├── index.json                      # 目录，不含包地址
├── <id>.json                       # 详情，额外含 package.path / sha256 / size
├── icons/<id>.png
└── packages/<id>-<version>.mpk
```

- `sha256`、`size` 由命令计算，不要手写；
- 同版本重复导入要加 `--force`，脚本已默认处理；
- 商店目录有 10 分钟缓存，上架后不会立即出现在客户端。

## 8. 多架构

- 一个 `id` 只能有一个包文件；多架构时把各架构二进制放进**同一个包**。
- `native.executable` 指向启动脚本，脚本按 `uname -m` 选择二进制：

```sh
#!/bin/sh
case "$(uname -m)" in
  x86_64|amd64)  BIN=app-amd64 ;;
  aarch64|arm64) BIN=app-arm64 ;;
  *) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac
DIR="$(dirname "$0")"
chmod +x "$DIR/$BIN" 2>/dev/null || true
exec "$DIR/$BIN" "$@"
```

- `architectures` 写全实际支持的架构；不要拆分发包，否则商店会互相覆盖。
- 只有一种架构就只写那一种；其他架构的机器上应用会直接不显示。

## 9. 第三方与合规

- 每个应用目录必须有 `README.md`，写明：上游名称与链接、许可证、是否官方移植、已知限制。
- 仓库**不分发**未获授权的专有运行时、官方安装包或破解资源。
- 图标等品牌资源仅用于标识对应应用，不声明版权；权利人要求时移除。
- manifest、脚本、文档中不要出现密钥、令牌、Cookie、内网地址。
- 需要用户密码时使用 `wizard` 的 `password` 字段；API 返回恒为 `__MASKED__`。

## 10. 应用 README 模板

```markdown
# <应用名>

一句话说明这个应用在 NAS 上做什么。

> 非官方移植 / 非官方打包，与 <上游> 无关。
> 本目录不包含 <应用名> 的官方安装包或未授权运行时。

- 上游：
- 许可证：
- 架构：amd64 / arm64
- 商店分组：

## 安装
## 首次配置
## 数据目录
## 已知限制
## 许可与商标
```
