### Install Server
```bash
export K3S_DOWNLOAD_URL=https://github.com/backrise/k3s/releases/download/v1.28.4%2Bk3s2-notraefik-release/k3s # optional, if you don't need traefik
mkdir -p /opt/k3s && cd /opt/k3s
wget -q -O install.sh https://apiv1.github.io/K8s/k3s/install.sh && chmod +x install.sh
K3S_MODE=server sh install.sh # Server模式, 单机使用K3S

cat /etc/rancher/k3s/k3s.yaml # auth file

# K3S_TOKEN, 也可以在Server启动时用环境变量和参数指定
# https://docs.k3s.io/zh/cli/token
cat /opt/k3s/lib/k3s/server/token

# 可选: 另一台主机使用Agent模式, 和Server组成多机K3S集群. TOKEN和URL填Server机器的.

# K3S_URL: k3s.yaml里有写
K3S_MODE=agent K3S_TOKEN=xxxxx K3S_URL=xxxxx sh install.sh
```

### Remove traefik
ExecStart: --disable traefik --disable traefik-crd
```bash
rm lib/k3s/server/manifests/traefik.yaml

kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd

# or

k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
```

### deploy_with_registries.sh
```bash
#!/bin/sh

INSTALL_SH_URL=https://apiv1.github.io/K8s/k3s/install.sh
USERNAME=<Your>
PASSWORD=<Your>
IMAGE_REGISTRY=<Your>
IMAGE_REGISTRY_URL=http://${IMAGE_REGISTRY}

mkdir -p /opt/k3s && cd /opt/k3s

cat <<EOF > registries.yaml
mirrors:
  "image.registry":
    endpoint:
      - "${IMAGE_REGISTRY_URL}"
configs:
  "${IMAGE_REGISTRY}":
    auth:
      username: $USERNAME
      password: $PASSWORD
EOF

wget -q -O - ${INSTALL_SH_URL} | K3S_MODE=server sh

echo . /opt/k3s/.env >> /root/.bash_profile

cd -
```

### deploy helm by kubectl
[https://rancher.com/docs/k3s/latest/en/helm/](https://rancher.com/docs/k3s/latest/en/helm/)
```bash
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: example
  namespace: default
spec:
  set:
    env: 'production'
  chart: https://example.com/chart.tgz
```

### offline install
[Auto deploying manifests && charts](https://docs.rancher.cn/docs/k3s/helm/_index/)
[Auto deploying images](https://docs.rancher.cn/docs/k3s/installation/airgap/_index)

image: ./lib/k3s/agent/images<br>
manifest: ./lib/k3s/server/manifests<br>
charts: ./lib/k3s/server/static/charts<br>