# 上架前验收清单

每个应用、每个声明支持的架构都要过一遍；未在真机验证的项不要勾。

## 源目录与构建

- [ ] `id`、`version`、`name`、`runtime`、`web` 等必填字段齐全，升级时 `version` 已递增
- [ ] `store` 段的 `category`、`author`、`developer` 已填写
- [ ] `architectures` 与实际提供的二进制一致
- [ ] `icon` 路径在包内存在，格式为 PNG / JPEG / WebP / SVG
- [ ] 源目录没有符号链接、设备文件、FIFO
- [ ] `manifest.json` 无注释、无尾随逗号、无未知字段，编码为 UTF-8
- [ ] `mpkpack validate apps/<id>` 通过
- [ ] `mpkpack build` 成功，且 `mpkpack validate <mpk>` 通过

## 安装

- [ ] 在 M·Desk 后台「应用中心 → 安装应用」选择 mpk，安装成功
- [ ] 应用出现在列表，名称、图标、版本正确
- [ ] 有向导时：必填、`pattern`、`min`/`max` 校验生效
- [ ] `password` 字段在设置页显示为 `__MASKED__`
- [ ] 安装完成后状态可启动，没有依赖缺失提示

## 启动与访问

- [ ] 启动后状态变为「运行中」
- [ ] `openPath` 页面能打开，不是 404 / 502
- [ ] `healthPath` 返回 2xx/3xx（401/403 也算服务存活）
- [ ] 页面静态资源无 404；socket 模式重点检查 `/apps/<id>/` 前缀
- [ ] Cookie 的 `Path` 正确，刷新后登录态保持
- [ ] port 模式在首选端口被占用时能改分配并正常启动
- [ ] 停止后进程退出，端口 / Socket 释放

## 功能

- [ ] 首次登录 / 初始化流程可完成
- [ ] 核心动作可完成（发送、上传、下载、保存等）
- [ ] 重启应用后数据与登录态保留（已正确使用 `${MDESK_DATA_DIR}`）
- [ ] 从另一台设备 / 浏览器访问，数据一致
- [ ] 向导设置的配置在「应用设置」里可修改并生效

## 升级与卸载

- [ ] 同 `id`、更高 `version` 覆盖安装成功
- [ ] 升级后用户数据、配置、登录态保留
- [ ] 升级后启动脚本与随包程序权限正常
- [ ] 卸载后进程停止，端口 / Socket 释放
- [ ] 重新安装可正常使用

## 多架构

- [ ] `architectures` 写全实际支持的架构，未虚报
- [ ] 启动脚本按 `uname -m` 选中正确二进制
- [ ] 启动脚本对随包二进制执行了 `chmod +x`
- [ ] 每个声明支持的架构都实际安装并启动验证
- [ ] 不支持的架构上应用不显示，而不是装完启动失败

## 商店目录

- [ ] `bash scripts/build-all.sh` 全量通过
- [ ] `bash scripts/build-market.sh` 生成 `index.json`、`<id>.json`、`icons/`、`packages/`
- [ ] `<id>.json` 的 `package.path`、`package.sha256`、`package.size` 与实际包一致
- [ ] `index.json` 条目不含 `package` 段
- [ ] 静态站点能访问 `/MPK/index.json`、图标和包文件
- [ ] 同版本重新导入带 `--force` 后目录内容正确
- [ ] 等待 10 分钟缓存后在客户端确认可见

## 安全与合规

- [ ] manifest、脚本、README 中没有密钥、令牌、Cookie、内网地址
- [ ] 日志不会打印密码或令牌
- [ ] 应用 README 写明上游、许可证、非官方移植声明
- [ ] 未打包未获授权的专有运行时或官方安装包
- [ ] 品牌图标仅用于标识应用，未声明版权
