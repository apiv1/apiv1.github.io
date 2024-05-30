build
```shell
# 1. 下载nacos-server压缩包, 解压到 nacos 目录
tar xvr nacos-server-*.tar.gz

# nacos/conf/application.properties 里添加 nacos.core.auth.default.token.secret.key
# 参考 nacos/conf/application.properties.example

# 2. 执行构建
docker buildx build . --platform linux/amd64,linux/arm64 -t apiv1/nacos --push

# 3. 删除 nacos 目录
rm -rf nacos
```