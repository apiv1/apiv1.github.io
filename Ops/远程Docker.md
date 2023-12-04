
### docker服务器配置(需要已安装docker服务,运行SSH)
假设账户为docker
主机名为: docker.server
```shell
# docker机器需要有个docker账户, 需要配置docker访问权限
useradd -m -s /bin/bash docker
vi ~/.ssh/authorized_keys # 贴入你的公钥, 为了远程ssh访问docker
# 配置好后在本机用ssh连接一下远程机器, 确认密钥, 避免使用ssh-docker时"确认密钥"流程阻塞住操作.

# 若在docker用户下使用docker还是提示无权限
# 1. 重启docker
# 2. 检查能否有docker.sock的访问权限(他的文件夹可能都没有访问权限)
```

本地配置
```shell
docker context create --docker host=ssh://docker@docker.server --description="docker-server" docker-server

# 使用远程docker
docker context use docker-server

# 使用本地 docker(还原)
docker context use default

# 本地查看远程htop
docker run -it --rm --pid=host jess/htop
```