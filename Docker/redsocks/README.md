build
```shell
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/redsocks
```

run
```shell
docker run --privileged=true --net=host -d apiv1/redsocks 1.2.3.4 3128
```