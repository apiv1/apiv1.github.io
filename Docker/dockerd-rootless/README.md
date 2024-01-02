# Linux 在线rootless安装Docker
```bash
# 在这里查看版本 https://download.docker.com/linux/static/stable/x86_64
# 自动检查并安装最新版本, 或使用环境变量指定版本如: export DOCKER_VERSION=24.0.6
mkdir -p ~/.dockerd && cd ~/.dockerd
wget -q -O install.sh https://apiv1.github.io/Docker/dockerd-rootless/install.sh && chmod +x install.sh
./install.sh
```