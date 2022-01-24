### Install Server
```bash
mkdir -p /opt/k3s && cd /opt/k3s
wget -q -O - https://apiv1.github.io/note/K8s/k3s/install.sh | K3S_MODE=server sh

cat /etc/rancher/k3s/k3s.yaml # auth file
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

INSTALL_SH_URL=https://apiv1.github.io/note/K8s/k3s/install.sh
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
  chart: https://example.com/cahrt.tgz
```

### offline install
[https://docs.rancher.cn/docs/k3s/installation/airgap/_index](https://docs.rancher.cn/docs/k3s/installation/airgap/_index)