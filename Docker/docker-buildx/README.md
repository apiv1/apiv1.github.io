### build

```shell
export DOCKER_BUILDX_VERSION=v0.12.0
# apiv1/buildx
docker build . --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION  -t apiv1/buildx -t apiv1/buildx:$DOCKER_BUILDX_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION --push -t apiv1/buildx -t apiv1/buildx:$DOCKER_BUILDX_VERSION
```