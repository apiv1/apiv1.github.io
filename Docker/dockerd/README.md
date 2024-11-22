# 安装前的设置

仅某些机器需要设置, 大部分机器能直接执行脚本安装

```shell

# apparmor(https://github.com/docker/for-linux/issues/1199#issuecomment-1431571192)
sudo apt install apparmor
# 安装完成后需要重启

sudo apt install iptables
```

# Linux 在线all in one安装Docker

```bash
# 在这里查看版本 https://download.docker.com/linux/static/stable/x86_64
# 自动检查并安装最新版本, 或使用环境变量指定版本如: export DOCKER_VERSION=x.y.z

export DOWNLOAD_DOCKER_SITE=https://mirror.iscas.ac.cn/docker-ce # 可选， 使用镜像站点下载

mkdir -p /opt/dockerd && cd /opt/dockerd
alias wget='wget --no-check-certificate --timeout=3 --tries=10'
wget -q -O install.sh https://apiv1.github.io/Docker/dockerd/install.sh && chmod +x install.sh
./install.sh
. .envrc
```
***他会提示你把```source /path/to/.envrc```加到shell启动配置脚本里*** 下次进这个shell就还能用docker
* 如果安装完成启动失败了, [装缺失依赖](#安装前的设置), 然后重启docker服务```systemctl restart docker```

dockerd配置文件, 可配置[Docker镜像源](../../Mirrors/Docker镜像源.md)
```shell
vim $DOCKER_HOME/daemon.json # 编辑配置
systemctl restart docker # 重启以应用配置
```

### 可选: Linux下使用Docker安装Docker组件(速度快)
```shell
cd $DOCKER_HOME/bin

# 安装 docker-compose
docker container create --pull always --name docker-compose-container apiv1/docker-compose
docker container cp docker-compose-container:/usr/local/bin/docker-compose .
docker container remove docker-compose-container
type docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && ln -s $(which docker-compose) /usr/local/lib/docker/cli-plugins/

# 安装docker-buildx
docker container create --pull always --name buildx-container apiv1/docker-buildx
docker container cp buildx-container:/usr/local/bin/docker-buildx .
docker container remove buildx-container
type docker-buildx && mkdir -p /usr/local/lib/docker/cli-plugins && ln -s $(which docker-buildx) /usr/local/lib/docker/cli-plugins/
```

### 可选: 为dockerd配置代理
[出处](https://markvanlent.dev/2022/05/10/pulling-docker-images-via-a-socks5-proxy/)

创建文件 /etc/systemd/system/docker.service.d/proxy.conf, 内容如下
```shell
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:8080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:8080"
```
127.0.0.1:8080是socks5服务的端口

### ~~可选是否安装docker-compose~~

```bash
export DOCKER_COMPOSE_VERSION=v2.24.0 # https://github.com/docker/compose/releases/latest
export INSTALL_FILE_PATH=/opt/dockerd/bin/docker-compose
wget -O $INSTALL_FILE_PATH https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
```

### ~~可选是否安装docker-buildx~~

```bash
export DOCKER_BUILDX_VERSION=v0.12.0 # https://github.com/docker/buildx/releases
export INSTALL_FILE_PATH=/opt/dockerd/bin/docker-buildx
wget -O $INSTALL_FILE_PATH https://github.com/docker/buildx/releases/download/$DOCKER_BUILDX_VERSION/buildx-$DOCKER_BUILDX_VERSION.linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
mkdir -p ~/.docker/cli-plugins
ln -s $INSTALL_FILE_PATH ~/.docker/cli-plugins/docker-buildx
```