### build

```shell
export DOCKER_VERSION=25.0.0
# apiv1/dind
docker build . --build-arg DOCKER_VERSION=$DOCKER_VERSION  -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_VERSION=$DOCKER_VERSION --push -t apiv1/dind -t apiv1/dind:$DOCKER_VERSION
```