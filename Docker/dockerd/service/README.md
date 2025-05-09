# 安装Dockerd管理服务

### 安装前的设置

仅某些机器需要设置, 大部分机器能直接执行脚本安装

```shell

# apparmor(https://github.com/docker/for-linux/issues/1199#issuecomment-1431571192)
sudo apt install apparmor
# 安装完成后, 如果不能用就需要重启

sudo apt install iptables
```

开始安装

```shell
# 在这里查看版本 https://download.docker.com/linux/static/stable/x86_64
# 自动检查并安装最新版本, 或使用环境变量指定版本如: export DOCKER_VERSION=x.y.z

export DOWNLOAD_DOCKER_SITE=https://mirror.iscas.ac.cn/docker-ce # 可选， 使用镜像站点下载
alias wget='wget --no-check-certificate --timeout=10 --tries=10'

# root
mkdir -p /opt/dockerd && cd /opt/dockerd
wget -q -O service.sh https://apiv1.github.io/Docker/dockerd/service/service.sh && chmod +x service.sh
./service.sh install
./service.sh up
. .envrc
# -------------------

# rootless only
mkdir -p ~/.dockerd && cd ~/.dockerd
wget -q -O service.sh https://apiv1.github.io/Docker/dockerd/service/service.sh && chmod +x service.sh
./service.sh install-rootless
./service.sh up
. .envrc
# -------------------

# root and rootless
mkdir -p /opt/dockerd && cd /opt/dockerd
wget -q -O service.sh https://apiv1.github.io/Docker/dockerd/service/service.sh && chmod +x service.sh
./service.sh install-rootless
. .envrc
# -------------------

# 在不同用户下启动, 可以自动选择启用dockerd还是dockerd-rootless
dockerd-service up # root user / rootless user
```
***他会提示你把```. /path/to/.envrc```加到shell启动配置脚本里*** 下次进这个shell就还能用docker
* 如果安装完成启动失败了, [装缺失依赖](#安装前的设置), 然后重启docker服务```dockerd-service down; dockerd-service up```

### 可选: Linux下使用Docker安装Docker组件(速度快)
```shell
cd $DOCKERD_HOME/bin

# 安装 docker-compose
docker container create --pull always --name docker-compose-container apiv1/docker-compose
docker container cp docker-compose-container:/usr/local/bin/docker-compose .
docker container remove docker-compose-container

# docker
type docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && ln -sf $(which docker-compose) /usr/local/lib/docker/cli-plugins/

# docker rootless
test -f ~/.docker/cli-plugins/docker-compose || (mkdir -p ~/.docker/cli-plugins; ln -s $PWD/docker-compose ~/.docker/cli-plugins/docker-compose)

# 安装docker-buildx
docker container create --pull always --name buildx-container apiv1/docker-buildx
docker container cp buildx-container:/usr/local/bin/docker-buildx .
docker container remove buildx-container

# docker
type docker-buildx && mkdir -p /usr/local/lib/docker/cli-plugins && ln -sf $(which docker-buildx) /usr/local/lib/docker/cli-plugins/

# docker rootless
test -f ~/.docker/cli-plugins/docker-buildx || (mkdir -p ~/.docker/cli-plugins; ln -s $PWD/docker-buildx ~/.docker/cli-plugins/docker-buildx)
```

### 参考
* [dockerd安装](../README.md)
* [dockerd-rootless安装](../rootless/README.md)