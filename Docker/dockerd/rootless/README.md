# Linux 在线rootless安装Docker

**需要登录(ssh/图形界面)非root账户, 不能直接用su切换用户, 会导致XDG_RUNTIME_DIR环境变量异常**

##### 安装前的设置
```shell
sudo sh -eux <<EOF
# Install newuidmap & newgidmap binaries
apt-get install -y uidmap
EOF
```

##### 设置安全规则

临时
```shell
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0 # 临时设置
```

永久设置
```shell
sudo vim /etc/sysctl.conf # 添加/修改 kernel.apparmor_restrict_unprivileged_userns=0
sudo sysctl -p # 应用变更
```


开始安装
```bash
# 在这里查看版本 https://download.docker.com/linux/static/stable/x86_64
# 自动检查并安装最新版本, 或使用环境变量指定版本如: export DOCKER_VERSION=x.y.z
export DOWNLOAD_DOCKER_SITE=https://mirror.iscas.ac.cn/docker-ce # 可选， 使用镜像站点下载

mkdir -p ~/.dockerd && cd ~/.dockerd
alias wget='wget --no-check-certificate --timeout=10 --tries=10'
wget -q -O install-rootless.sh https://apiv1.github.io/Docker/dockerd/rootless/install-rootless.sh && chmod +x install-rootless.sh
./install-rootless.sh
. .envrc
```

***他会提示你把```. /path/to/.envrc```加到shell启动配置脚本里*** 下次进这个shell就还能用docker
* 如果安装失败了, [装缺失依赖](#安装前的设置), 然后重新安装```./install-rootless```

dockerd配置文件, 可配置[Docker镜像源](../../Mirrors/Docker镜像源.md)
```shell
vim $DOCKERD_HOME/daemon.json # 编辑配置
systemctl --user restart docker # 重启以应用配置
```

### 可选: Linux下使用Docker安装Docker组件(速度快)
```shell
cd ./bin

# 安装 docker-compose
docker container create --pull always --name docker-compose-container apiv1/docker-compose
docker container cp docker-compose-container:/usr/local/bin/docker-compose .
docker container remove docker-compose-container
test -f ~/.docker/cli-plugins/docker-compose || (mkdir -p ~/.docker/cli-plugins; ln -s $PWD/docker-compose ~/.docker/cli-plugins/docker-compose)

# 安装docker-buildx
docker container create --pull always --name buildx-container apiv1/docker-buildx
docker container cp buildx-container:/usr/local/bin/docker-buildx .
docker container remove buildx-container
test -f ~/.docker/cli-plugins/docker-buildx || (mkdir -p ~/.docker/cli-plugins; ln -s $PWD/docker-buildx ~/.docker/cli-plugins/docker-buildx)
```

### ~~可选是否安装docker-compose~~

```bash
export DOCKER_COMPOSE_VERSION=v2.24.0 # https://github.com/docker/compose/releases/latest
export INSTALL_FILE_PATH=~/.dockerd/bin/docker-compose
wget -O $INSTALL_FILE_PATH https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
```

### ~~可选是否安装docker-buildx~~

```bash
export DOCKER_BUILDX_VERSION=v0.12.0 # https://github.com/docker/buildx/releases
export INSTALL_FILE_PATH=~/.dockerd/bin/docker-buildx
wget -O $INSTALL_FILE_PATH https://github.com/docker/buildx/releases/download/$DOCKER_BUILDX_VERSION/buildx-$DOCKER_BUILDX_VERSION.linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
mkdir -p ~/.docker/cli-plugins
ln -sf $INSTALL_FILE_PATH ~/.docker/cli-plugins/docker-buildx
```
