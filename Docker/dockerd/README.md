# Linux 在线all in one安装Docker (推荐)
```bash
export DOCKER_VERSION=20.10.9 # 在这里看最新版本 https://download.docker.com/linux/static/stable/x86_64
mkdir -p /opt/dockerd && cd /opt/dockerd
wget -q -O - https://apiv1.github.io/Docker/dockerd/all-in-one.sh | sh
```

# Linux手动安装Docker

需要在root权限

1. 手动下载解压docker程序
```bash
mkdir -p /opt/dockerd && cd /opt/dockerd
export DOCKER_VERSION=20.10.9
wget https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz
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
export DOCKER_COMPOSE_VERSION=v2.5.0
export INSTALL_FILE_PATH=/opt/dockerd/docker/docker-compose
wget -O $INSTALL_FILE_PATH https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64
chmod +x $INSTALL_FILE_PATH
```