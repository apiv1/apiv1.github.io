```shell
# 删除已退出的容器
docker rm $(docker ps -a | grep Exited | awk '{print $1}')

# 删除未被tag的镜像
docker rmi $(docker images -a | grep none | awk '{print $3}')

# 创建支持多平台打包的容器
docker buildx create --name multi-platform --use --platform linux/amd64,linux/arm64 --driver docker-container

# 列出容器启动的命令
alias get_command_4_run_container='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock cucker/get_command_4_run_container'
get_command_4_run_container $CONTAINER_ID # 传container名字/ID
```