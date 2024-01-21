build
```shell
export DOCKER_COMPOSE_VERSION=v2.24.0
# apiv1/code-server
docker build . --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION  -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION --push -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
```