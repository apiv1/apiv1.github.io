### build

```shell
# apiv1/sshd
docker build .  --target sshd -t apiv1/sshd --push
docker build .  --target docker -t apiv1/sshd:docker --push
docker build .  --target dockerd -t apiv1/sshd:dockerd --push

docker buildx build . --platform linux/amd64,linux/arm64 --target sshd --pull --push -t apiv1/sshd
docker buildx build . --platform linux/amd64,linux/arm64 --target docker --pull --push -t apiv1/sshd:docker
docker buildx build . --platform linux/amd64,linux/arm64 --target dockerd --pull --push -t apiv1/sshd:dockerd
```