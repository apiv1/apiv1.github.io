### Install Server
```bash
mkdir -p /opt/k3s && cd /opt/k3s
wget -q -O - https://apiv1.github.io/note/K8s/k3s/install.sh | K3S_MODE=server sh

cat /etc/rancher/k3s/k3s.yaml # auth file
```

### Remove traefik
ExecStart: --disable traefik --disable traefik-crd
```bash
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
```

### private-registry
from [https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/](https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/)<br>

registries.yaml
```
mirrors:
  "image.registry":
    endpoint:
      - "http://image.registry"
configs:
  "image.registry":
    auth:
      username: $USERNAME
      password: $PASSWORD
```

### setting image.registry ip
```bash
sed -i "/.*#.*SETTING.*image\.registry.*/d" /etc/hosts
echo $IMAGE_REGISTRY_IP' image.registry # SETTING: image.registry' >> /etc/hosts
```