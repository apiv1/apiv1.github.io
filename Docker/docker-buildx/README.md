### build

```shell
export DOCKER_BUILDX_VERSION=v0.12.0
# apiv1/docker-buildx
docker build . --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION  -t apiv1/docker-buildx -t apiv1/docker-buildx:$DOCKER_BUILDX_VERSION

docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION --push -t apiv1/docker-buildx -t apiv1/docker-buildx:$DOCKER_BUILDX_VERSION
```

### Linux下安装docker-buildx (从容器里拷贝到当前目录)

```shell
docker container create --name buildx-container apiv1/docker-buildx
docker container cp buildx-container:/docker-buildx docker-buildx
docker container remove buildx-container
```