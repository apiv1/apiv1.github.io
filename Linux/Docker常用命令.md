```shell
# 删除已退出的容器
docker rm $(docker ps -a | grep Exited | awk '{print $1}')

# 删除未被tag的镜像
docker rmi $(docker images -a | grep none | awk '{print $3}')

# 创建支持多平台打包的容器
docker buildx create --name multi-platform --use --platform linux/amd64,linux/arm64 --driver docker-container
```