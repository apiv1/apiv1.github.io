1. 安装metallb, 用于分配ip (无法为LoadBalancer分配ip的时候需要安装)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install metallb bitnami/metallb
vim metallb.yml # 修改配置, 设置分配ip范围 (单机版用自身ip: x.x.x.x/32 )
kubectl apply -f metallb.yml
```

2. 安装 cert-manager, 配置cluster-issuer

```bash
# https://artifacthub.io/packages/helm/cert-manager/cert-manager
# https://github.com/cert-manager/cert-manager/releases
export CERT_MANAGER_VERSION=1.14.3
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v${CERT_MANAGER_VERSION}/cert-manager.crds.yaml
helm repo add cert-manager https://charts.jetstack.io
helm install cert-manager cert-manager/cert-manager --version ${CERT_MANAGER_VERSION}
vim cluster-issuer-<env>.yml # 修改配置, 设置邮箱
kubectl apply -f cluster-issuer-<env>.yml
```

#### 证书更新失败处理
* [Certificate not renewing, referencing unknown order? #3494](https://github.com/cert-manager/cert-manager/discussions/3494)

查看生成失败原因
```shell
kubectl get CertificateRequest
kubectl describe CertificateRequest/xxx
```

或者删除READY为false的证书, 等待重新生成
```shell
kubectl get cert
```

#### 注册https证书时, "All hosts are taken by other resources" 处理
* [出处](https://www.coder.work/article/7749722)

kubectl logs -f deploy/nginx-ingress-controller 报错 "All hosts are taken by other resources"

* 解决: ingress内添加
```yaml
annotations:
  acme.cert-manager.io/http01-edit-in-place: "true"
```
* (可选) 可能还要去掉一些 ```nginx.org/location-snippets```内定义的 ```rewrite``` 因为可能会影响证书服务器认证
* 然后删除ingress重新创建

### 安装步骤

1. 安装 ingress-nginx
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
vim ingress.yml #修改配置, 指向自己的service
kubectl apply -f ingress.yml
```

或者安装 nginx-ingress
```bash
helm repo add nginx https://helm.nginx.com/stable
helm install nginx-ingress nginx/nginx-ingress
```
其他步骤一样, ingress.yml可能有些微调整