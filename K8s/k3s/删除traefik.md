```bash
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
```

ExecStart 添加 --disable traefik --disable traefik-crd