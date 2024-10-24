### 查看k3s.yaml

```shell
docker compose exec k3s cat /etc/rancher/k3s/k3s.yaml
```

### run
```shell
docker run -d --name k3s --restart always --network host --hostname k3s --privileged \
  -v k3s_data:/var/lib/rancher/k3s \
  rancher/k3s:v1.28.3-k3s1 \
  server --disable agent --disable traefik
```

### run with config registries.yaml
```shell
vim registries.yaml
docker run -d --name k3s --restart always --network host --hostname k3s --privileged \
  -v k3s_data:/var/lib/rancher/k3s \
  -v ${PWD}/registries.yaml:/etc/rancher/k3s/registries.yaml \
  rancher/k3s:v1.28.3-k3s1 \
  server --disable agent --disable traefik
```