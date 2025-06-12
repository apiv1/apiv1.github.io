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


### docker容器里建立ssh连接

```shell
#!/bin/sh
SSH_BASE_ARGS="-o ServerAliveInterval=60 -o ServerAliveCountMax=60 -o ConnectTimeout=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
SSH_ARGS=$SSH_BASE_ARGS" -i ./id_rsa"
SSH_URL=""

docker run --restart always --name ssh-client -it -d --net host -v $PWD:/app -w /app --entrypoint ssh apiv1/sshd $SSH_ARGS $SSH_URL
```