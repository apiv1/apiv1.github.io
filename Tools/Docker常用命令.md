##### 常用命令

```shell
# 删除已退出的容器
docker rm $(docker ps -a | grep Exited | awk '{print $1}')

# 删除未被tag的镜像
docker rmi $(docker images -a | grep none | awk '{print $3}')

# 列出容器启动的命令
alias get_command_4_run_container='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock cucker/get_command_4_run_container'
get_command_4_run_container $CONTAINER_ID # 传container名字/ID
```

##### Mac系统上```docker login```失败解决
~/.docker/config.json 配置 ```credsStore```
改成这个
```json
{
  "credsStore": "osxkeychain"
}
```
指使用```docker-credential-osxkeychain```存储密码

密码存储程序的前缀是 ```docker-credential-```, 系统里会安装多个.

有多个不同的存储程序可选装: [docker/docker-credential-helpers](https://github.com/docker/docker-credential-helpers)

##### buildx 配置文件设置: [参考文档](https://github.com/docker/buildx/blob/master/docs/reference/buildx_create.md#buildkitd-config)

[配置文件例子](https://github.com/moby/buildkit/blob/master/docs/buildkitd.toml.md)
```shell
mkdir -p ~/.docker/buildx
vim ~/.docker/buildx/buildkitd.default.toml

docker buildx create --buildkitd-config ~/.docker/buildx/buildkitd.default.toml # 默认配置文件,不写也可以

# 创建支持多平台打包的容器
docker buildx create --name multi-platform --use --platform linux/amd64,linux/arm64 --driver docker-container

# 创建使用代理的容器 (好像没生效, 但是记录下)
docker buildx create --name multi-platform-proxy --use --platform linux/amd64,linux/arm64 --driver docker-container --driver-opt env.http_proxy=http://172.17.0.1:3128 --driver-opt env.https_proxy=http://172.17.0.1:3128 # http

docker buildx create --name multi-platform-proxy --use --platform linux/amd64,linux/arm64 --driver docker-container --driver-opt env.http_proxy=socks5://172.17.0.1:1080 --driver-opt env.https_proxy=socks5://172.17.0.1:1080 # socks
```

buildkitd.default.toml
```toml
# 配置代理仓库例子
[registry."docker.io"]
  mirrors = ["registry.docker-cn.com"]
```

##### Docker容器内配置代理
[参考文档](https://docs.docker.com/engine/cli/proxy/)

客户端版

~/.docker/config.json
```json
{
 "proxies": {
   "default": {
     "httpProxy": "http://proxy.example.com:3128",
     "httpsProxy": "https://proxy.example.com:3129",
     "noProxy": "*.test.example.com,.example.org,127.0.0.0/8"
   }
 }
}
```

Linux Server版

找到docker.service文件, 加这两行

```
[Service]
...
Environment="HTTP_PROXY=socks5://localhost:1080/"
Environment="NO_PROXY=localhost,127.0.0.1,registry-1.docker.io"
```

### Linux免root使用docker
```shell
sudo groupadd docker
sudo usermod -aG docker $USER
```