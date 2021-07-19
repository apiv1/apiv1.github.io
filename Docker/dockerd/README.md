# Linux手动安装Docker

需要在root权限

1. 手动下载解压docker程序
```bash
mkdir -p /opt && cd /opt
export DOCKER_VERSION=20.10.7
wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz
tar zxvf docker-${DOCKER_VERSION}.tgz && rm -rf docker-${DOCKER_VERSION}.tgz
```

2. 安装服务并启动
```bash
DOCKER_BIN=/opt/docker sh service-install.sh
```