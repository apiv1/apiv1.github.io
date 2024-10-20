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
wget -q -O install.sh https://apiv1.github.io/Docker/dockerd/all-in-one.sh && chmod +x install.sh
./install.sh
. .envrc

# 可选: Linux下使用Docker安装Docker组件(速度快)
cd ./bin

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

# ~~Linux手动安装Docker~~

需要在root权限

1. 手动下载解压docker程序

```bash
mkdir -p /opt/dockerd && cd /opt/dockerd
export DOCKER_VERSION=27.3.1
wget https://download.docker.com/linux/static/stable/$(uname -m)/docker-$DOCKER_VERSION.tgz
tar zxvf docker-$DOCKER_VERSION.tgz && rm -rf docker-$DOCKER_VERSION.tgz
mv docker bin
cd -
```

2. 安装服务并启动

```bash
DOCKER_BIN=/opt/dockerd/bin sh service-install.sh
```

3. 或者绿色安装Docker

```bash
# docker.tgz解压在当前目录中
# service-install.sh 在当前目录中
# daemon.json配置也可以放在当前目录, 如果无此配置自己生成一个空配置文件
sh install-portable.sh
```

* daemon.json配置

```
{ "registry-mirrors": ["https://registry-1.docker.io", "https://registry.cn-hangzhou.aliyuncs.com", "https://registry.docker-cn.com", "https://hub-mirror.c.163.com", "https://docker.mirrors.ustc.edu.cn"] }
```
