# [Docker](https://docs.docker.com/) 快速上手

什么是Docker:
  * **打包服务, 用容器运行服务**.
  * 比如把mysql打包到docker镜像里, 其他人下载了镜像直接就能运行, 装服务像装绿色软件一样.

什么是docker-compose:
  * 组合多个docker服务, 协同完成任务.
  * 比如配置nginx, redis, mysql, 和自己的应用程序服务在一个compose中, 运行compose自动起所有服务在同一个网络中协同工作.

什么是Dockerfile
  * 一个脚本, docker执行这个脚本能生成一个新的镜像.
  * 新手可以用别人做好的镜像, 自己不需要会写Dockerfile.

## 安装
---
* Linux服务器/树莓派看这里 >>> [Docker & docker-compose 一键绿色安装](../Docker/dockerd/README.md) <<<
* Linux Rootless安装docker 看这里 >>> [Docker Rootless 一键绿色安装](../Docker/dockerd/rootless/README.md) <<<
* 其他系统安装:
  - 命令行工具: 体积小,无需安装, **将程序放入PATH环境变量路径使用**.<br>
    *命令行客户端能使用[远程Docker](./远程Docker.md)(<small>指Docker服务端部署在其他机器上, 本机配置好后能使用docker客户端进行控制</small>).<br>
    下载:<br>
    [Docker Download](https://download.docker.com/) : 可以下载各平台Docker客户端二进制文件<br>
    [Docker-compose Download](https://github.com/docker/compose/releases/latest): 下载各平台docker-compose客户端二进制文件<br>
  - 桌面版程序(体积较大, 有界面, Windows需要专业版, 开Hyper-V或者WSL2)<br>
    下载:<br>
    [Docker Desktop](https://www.docker.com/products/docker-desktop/)

## [docker 命令](https://docs.docker.com/engine/reference/commandline/cli/)
---
主要掌握这些就能基本使用
```shell
docker run # 从镜像创建并运行新容器
docker exec # 在正在运行的容器中执行命令
docker ps # 列出容器
docker build # 从 Dockerfile 构建镜像
docker pull # 从仓库下载映像
docker push # 将镜像上传到仓库
docker images # 列出镜像
docker logs # 查看日志
docker rm # 删除容器
docker rmi # 删除镜像
```
这些命令需要用的时候对照本说明看一下, 查看命令参数添加 ```--help```. 没写上的其他命令就看```docker --help```

## [docker-compose 命令](https://docs.docker.com/compose/reference/)
---
主要掌握这些就能基本使用
```shell
docker-compose up # 拉起所有服务, 有参数可以后台启动服务, 也可以只启动单个服务
# 例子
$ docker-compose up -d # 后台启动所有服务
$ docker-compose up -d A B # 后台启动名为A和B的服务

docker-compose down # 停止所有服务, 也可以配置参数只停止单个服务
# 例子
$ docker-compose down A B # 停止A和B服务
$ docker-compose down --remove-orphans # 停止所有服务, 包括docker-compose未列出的服务

# 有些命令和docker命令差不多, 参数自己查
docker-compose run
docker-compose ps
docker-compose exec
docker-compose logs
```
这些命令需要用的时候对照本说明看一下, 查看命令参数添加 ```--help```. 没写上的其他命令就看```docker-compose --help```

### [写Dockerfile](https://docs.docker.com/engine/reference/builder/)
---
* 作用是构建镜像, ```docker build```执行构建
* [这本手册](../README.md)里有很多写好的Dockerfile, 在 ```/Docker```文件夹里

### [写compose.yml](https://docs.docker.com/compose/compose-file/)
---
* 作用是组合多个docker容器协同工作, ```docker-compose```读取yml配置进行操作.
* [这本手册](../README.md)里有很多写好的compose.yml, 在 ```/Docker```文件夹里