# Linux 在线rootless安装Docker
```bash
# 在这里查看版本 https://download.docker.com/linux/static/stable/x86_64
# 自动检查并安装最新版本, 或使用环境变量指定版本如: export DOCKER_VERSION=24.0.6
mkdir -p ~/.dockerd && cd ~/.dockerd
wget -q -O install.sh https://apiv1.github.io/Docker/dockerd-rootless/install.sh && chmod +x install.sh
./install.sh
```

### 可选是否安装docker-compose
```bash
export DOCKER_COMPOSE_VERSION=v2.24.0 # https://github.com/docker/compose/releases/latest
export INSTALL_FILE_PATH=~/.dockerd/bin/docker-compose
wget -O $INSTALL_FILE_PATH https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
```

### 可选是否安装docker-buildx
```bash
export DOCKER_BUILDX_VERSION=v0.12.0 # https://github.com/docker/buildx/releases
export INSTALL_FILE_PATH=~/.dockerd/bin/docker-buildx
wget -O $INSTALL_FILE_PATH https://github.com/docker/buildx/releases/download/$DOCKER_BUILDX_VERSION/buildx-$DOCKER_BUILDX_VERSION.linux-$(uname -m)
chmod +x $INSTALL_FILE_PATH
mkdir -p ~/.docker/cli-plugins
ln -sf $INSTALL_FILE_PATH ~/.docker/cli-plugins/docker-buildx
```