# Docker 快速上手

## 安装
* [Docker & docker-compose 一键绿色安装 (Linux服务器/树莓派)](./README.md)
* 其他系统安装:
  - 命令行工具: 体积小,无需安装.命令行客户端就能使用 [远程Docker](../../Ops/远程Docker.md)( Docker服务端部署在其他机器上, 本机配置好后能使用docker客户端进行控制). **将程序放入PATH环境变量路径使用**.
    [Docker Download](https://download.docker.com/) : 可以下载各平台Docker客户端二进制文件
    [Docker-compose release](https://github.com/docker/compose/releases/latest): 下载各平台docker-compose客户端二进制文件
  - 桌面版程序(体积较大, Windows需要专业版, 开Hyper-V或者WSL2)
    [Docker Desktop](https://www.docker.com/products/docker-desktop/)

## docker 常用命令, 主要掌握这些就能基本使用

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
这些命令需要用的时候对照本手册看一下, 查看命令参数添加 ```--help```. 没写上的其他命令就看```docker --help```

## docker-compose 常用命令, 主要掌握这些就能基本使用
```shell
docker-compose up # 拉起所有服务, 有参数可以后台启动服务, 也可以只启动单个服务
docker-compose down # 停止所有服务, 也可以配置参数只停止单个服务

# 有些命令和docker命令差不多, 参数自己查
docker-compose run
docker-compose ps
docker-compose exec
docker-compose logs
```
这些命令需要用的时候对照本手册看一下, 查看命令参数添加 ```--help```. 没写上的其他命令就看```docker-compose --help```