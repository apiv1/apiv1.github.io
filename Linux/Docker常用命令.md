```shell
# 删除已退出的容器
docker rm $(docker ps -a | grep Exited | awk '{print $1}')

# 删除未被tag的镜像
docker rmi $(docker images -a | grep none | awk '{print $3}')
```