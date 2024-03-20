### build

```shell
export DOCKER_VERSION=25.0.0
# apiv1/dind
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION  -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --push -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
```

### docker-dind
[docker-dind.envrc](./docker-dind.envrc)
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