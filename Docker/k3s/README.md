### 查看k3s.yaml

```shell
docker compose exec k3s cat /etc/rancher/k3s/k3s.yaml
```

### run
```shell
docker run -d --name k3s --restart always --network host --hostname k3s --privileged \
  -v k3s_data:/var/lib/rancher/k3s \
  rancher/k3s:v1.31.1-k3s1 \
  server --disable agent --disable traefik
```

### run with config registries.yaml
```shell
vim registries.yaml
docker run -d --name k3s --restart always --network host --hostname k3s --privileged \
  -v k3s_data:/var/lib/rancher/k3s \
  -v ${PWD}/registries.yaml:/etc/rancher/k3s/registries.yaml \
  rancher/k3s:v1.31.1-k3s1 \
  server --disable agent --disable traefik
```

registries.yaml
```yaml
mirrors:
  "docker.io":
    endpoint:
      - "https://dockerpull.org"
  "image.registry":
    endpoint:
      - "http://image.registry"
configs:
  "image.registry":
    auth:
      username: $USERNAME
      password: $PASSWORD
```