### build

```shell
export PROTOC_VERSION=29.2
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg PROTOC_VERSION=$PROTOC_VERSION --pull --push -t apiv1/protoc
```