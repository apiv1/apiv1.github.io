# 安装前的设置
仅某些机器需要设置, 大部分机器能直接执行脚本安装
```shell

# apparmor(https://github.com/docker/for-linux/issues/1199#issuecomment-1431571192)
sudo apt install apparmor
# 安装完成后需要重启

sudo apt install iptables
```

# Linux 在线all in one安装Docker (推荐)
```bash
export DOCKER_VERSION=24.0.6 # 在这里看最新版本 https://download.docker.com/linux/static/stable/x86_64
mkdir -p /opt/dockerd && cd /opt/dockerd
wget -q -O install.sh https://apiv1.github.io/Docker/dockerd/all-in-one.sh && chmod +x install.sh
./install.sh
```

# Linux手动安装Docker

需要在root权限

1. 手动下载解压docker程序
```bash
mkdir -p /opt/dockerd && cd /opt/dockerd
export DOCKER_VERSION=24.0.6
wget https://download.docker.com/linux/static/stable/$(arch)/docker-$DOCKER_VERSION.tgz
tar zxvf docker-$DOCKER_VERSION.tgz && rm -rf docker-$DOCKER_VERSION.tgz
cd -
```

2. 安装服务并启动
```bash
DOCKER_BIN=/opt/dockerd/docker sh service-install.sh
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
{ "registry-mirrors": ["https://registry-1.docker.io", "https://registry.cn-hangzhou.aliyuncs.com", "https://registry.docker-cn.com", "https://docker.mirrors.ustc.edu.cn"] }
```

### 可选是否安装docker-compose
```bash
export DOCKER_COMPOSE_VERSION=v2.22.0 # https://github.com/docker/compose/releases
export INSTALL_FILE_PATH=/opt/dockerd/docker/docker-compose
wget -O $INSTALL_FILE_PATH https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-$(arch)
chmod +x $INSTALL_FILE_PATH
```