# 商店目录（生成物）

此目录由 `mpkpack store` 生成，不要手动编辑：

- `index.json`：商店目录，列出全部应用，条目不包含包地址
- `<id>.json`：应用详情，额外包含 `package.path`、`package.sha256`、`package.size`
- `icons/<id>.png`：从包内解出的图标
- `packages/<id>-<version>.mpk`：应用包

重新生成：

```bash
bash scripts/build-all.sh
bash scripts/build-market.sh
```

生成的文件默认被 `.gitignore` 忽略，只保留本说明。部署时把整个 `www/MPK/` 目录同步到静态站点即可。
