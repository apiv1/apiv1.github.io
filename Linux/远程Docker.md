
### docker服务器配置
* 服务器需要已安装docker服务,运行SSH服务端
* 客户端需安装openssh, docker客户端

假设账户为docker
主机名为: docker.server
- - -
自己机器上先生成公钥```id_rsa.pub```
```shell
ssh-keygen # 默认生成到 $HOME/.ssh/id_rsa.pub
```

在远程Docker机器上
```shell
# docker机器需要有个docker账户, 需要配置docker访问权限
useradd -m -s /bin/bash docker
vi ~/.ssh/authorized_keys # 贴入你的公钥(生成的id_rsa.pub), 为了远程ssh访问docker
# 配置好后在本机用ssh连接一下远程机器, 确认密钥, 避免使用ssh-docker时"确认密钥"流程阻塞住操作.

vi ~/.bashrc # 非登录shell会加载此文件，如果需要配置docker相关的环境变量，在这里配置。其他地方配置没有用。

# 若在docker用户下使用docker还是提示无权限
# 1. 重启docker
# 2. 检查能否有docker.sock的访问权限(他的文件夹可能都没有访问权限)
```
本地配置远程Docker连接(临时)
```shell
export $DOCKER_HOST=ssh://docker@docker.server:22

ssh $DOCKER_HOST # 测试连接,确认密钥配置生效

# 查看docker entrypoint配置
docker context ls

# 愉快的使用远程docker
docker ps -a

# 使用本地 docker(还原)
unset $DOCKER_HOST
```

本地配置远程Docker连接(永久)
```shell
export DOCKER_HOST=ssh://docker@docker.server:22
$env:DOCKER_HOST="ssh://docker@docker.server:22" # powershell

ssh $DOCKER_HOST # 测试连接,确认密钥配置生效

docker context create --docker host=$DOCKER_HOST --description="docker-server" docker-server

# 使用远程docker
docker context use docker-server

# 使用本地 docker(还原)
docker context use default
```

本地查看远程htop
```shell
docker run -it --rm --pid=host jess/htop
```