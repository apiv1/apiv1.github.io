### build

```shell
export DOCKER_VERSION=27.3.1

# apiv1/dockerd
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION --target dockerd -t apiv1/dockerd -t apiv1/dockerd:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --target dockerd --push -t apiv1/dockerd -t apiv1/dockerd:$DOCKER_VERSION

# apiv1/docker
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION --build-arg DOCKERD_STAGE=apiv1/dockerd:$DOCKER_VERSION  -t apiv1/docker -t apiv1/docker:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --build-arg DOCKERD_STAGE=apiv1/dockerd:$DOCKER_VERSION --push -t apiv1/docker -t apiv1/docker:$DOCKER_VERSION
```

### Dood
docker out of docker: 在容器里调用宿主机Docker服务实现功能

[bash/zsh版本](./docker.envrc)
[powershell版本](./docker.ps1)

* [Dockered](../dockerd/README.md) 环境中安装 dood
```shell
mkdir -p $DOCKERD_HOME/.envrc.d
cd $DOCKERD_HOME/.envrc.d
wget https://apiv1.github.io/Docker/docker/docker.envrc
cd -
```