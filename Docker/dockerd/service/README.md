# 安装Dockerd管理服务

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

### 参考
* [dockerd安装](../README.md)
* [dockerd-rootless安装](../rootless/README.md)