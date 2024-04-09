# Dind (docker in docker)
在容器里调用宿主机Docker服务实现功能

### build

```shell
export DOCKER_VERSION=26.0.0

# apiv1/docker:full
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION --target full -t apiv1/docker:full -t apiv1/docker:full-$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --target full --push -t apiv1/docker:full -t apiv1/docker:full-$DOCKER_VERSION

# apiv1/docker
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION --build-arg DOCKER_FULL_STAGE=apiv1/docker:full-$DOCKER_VERSION  -t apiv1/docker -t apiv1/docker:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --build-arg DOCKER_FULL_STAGE=apiv1/docker:full-$DOCKER_VERSION --push -t apiv1/docker -t apiv1/docker:$DOCKER_VERSION
```

### docker-dind

* docker-dind: 在容器里使用docker的命令
* docker-buildx: 在容器里使用docker-buildx的命令
* docker-compose: 在容器里使用docker-compose的命令
* docker: 重定向docker子命令

[bash/zsh版本](./docker.envrc)
[powershell版本](./docker.ps1)

* [Dockered](../dockerd/README.md) 环境中安装 docker-dind
```shell
cd $DOCKER_HOME/.envrc.d
wget https://apiv1.github.io/Docker/dind/docker.envrc
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