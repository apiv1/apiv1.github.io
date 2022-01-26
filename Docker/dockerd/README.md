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

3. 或者绿色安装Docker
```bash
# docker.tgz解压在当前目录中
# service-install.sh 在当前目录中
# daemon.json配置也可以放在当前目录, 如果无此配置自己生成一个空配置文件
sh install-portable.sh
```

4. 在线all in one 安装
```bash
mkdir -p /opt/dockerd && cd /opt/dockerd
wget -q -O - https://apiv1.github.io/note/Docker/dockerd/all-in-one.sh | sh
```

5. daemon.json配置
```
{ "registry-mirrors": ["https://registry-1.docker.io", "https://registry.cn-hangzhou.aliyuncs.com", "https://registry.docker-cn.com"] }
```