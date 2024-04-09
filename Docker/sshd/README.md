### build

```shell
# apiv1/sshd
docker build .  -t apiv1/sshd --push

docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/sshd
```