```shell
docker run --restart always --name k3s -d --privileged --net host -v k3s_data:/var/lib/rancher -v k3s_config:/etc/rancher rancher/k3s server --disable traefik
```