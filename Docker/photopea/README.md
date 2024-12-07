build

```shell
docker buildx build . --platform linux/amd64,linux/arm64 -t apiv1/photopea --pull --push
```

run

```shell
docker run --rm -d --restart always --name photopea -p 80:80 apiv1/photopea
```