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

k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
```