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

```shell
# 安装 docker-dind
wget -O $DOCKER_HOME/.envrc.d/docker-dind.envrc https://apiv1.github.io/Docker/dind/docker-dind.envrc
```