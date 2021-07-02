1. 安装metallb, 用于分配ip (无法为LoadBalancer分配ip的时候需要安装)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install metallb bitnami/metallb
vim metallb.yml # 修改配置, 设置分配ip范围 (单机版用自身ip: x.x.x.x/32 )
kubectl apply -f metallb.yml
```

2. 安装 cert-manager, 配置cluster-issuer

```bash
helm repo add cert-manager https://charts.jetstack.io
helm install cert-manager cert-manager/cert-manager
vim cluster-issuer-<env>.yml # 修改配置, 设置邮箱
kubectl apply -f cluster-issuer-<env>.yml
```

3. 安装 ingress-nginx
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
vim ingress.yml #修改配置, 指向自己的service
kubectl apply -f ingress.yml
```