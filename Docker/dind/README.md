# Dind (docker in docker)
在容器里调用宿主机Docker服务实现功能

### build

```shell
export DOCKER_VERSION=25.0.0
# apiv1/dind
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION  -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --push -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
```

### docker-dind

* docker-dind: 在容器里使用docker的命令
* docker-buildx: 在容器里使用docker-buildx的命令
* docker-compose: 在容器里使用docker-compose的命令
* docker: 重定向docker子命令

[bash/zsh版本](./docker-dind.envrc)
[powershell版本](./docker-dind.ps1)

* [Dockered](../dockerd/README.md) 环境中安装 docker-dind
```shell
cd $DOCKER_HOME/.envrc.d
wget https://apiv1.github.io/Docker/dind/docker-dind.envrc
cd -
```

### docker hook
* 将docker工具作为docker子命令调用
  * docker compose -> docker-compose
  * docker buildx -> docker-buildx

安装
```shell
cd $DOCKER_HOME/.envrc.d
echo \
'docker() {
  local COMMAND=$1
  shift 1
  if type "docker-$COMMAND" >/dev/null 2>&1; then
    "docker-$COMMAND" $*
  else
    $(which docker) $COMMAND $*
  fi
}'\
> docker.envrc
cd -
```

### 在其他的compose project中安装docker组件, 实现dind
* 把docker客户端等二进制文件安装在容器内/root/.bin, /root/.docker/cli-plugins 等目录中实现dind
* 可以使用docker,docker-compose, docker-buildx等功能
* 需持久化/root目录
* 需映射docker.sock

配置compose.yml例子
```yml
volumes:
  - root:/root
  - ${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock
```

制作dind镜像: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

执行
```shell
# DIND_IMAGE: 打包了compose文件的镜像
export DIND_IMAGE=<镜像名称>
wget -O - https://apiv1.github.io/Docker/dind/install-docker.yml | NO_TTY=1 dind-run $DIND_IMAGE -f - run --rm --build install-docker
```