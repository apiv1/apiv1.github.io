### K3S的安装
##### 安装客户端
[官方文档](https://kubernetes.io/zh-cn/docs/tasks/tools/)

##### 安装服务端, 安装Server以及Agent的说明
一键安装脚本, 比官方的更绿色
```bash
# 可选: 添加你的IP, 加入tls. (部分主机需要此配置, 否则需要kubectl --insecure-skip-tls-verify命令来跳过tls校验)
# https://docs.k3s.io/installation/configuration#registration-options-for-the-k3s-server
export HOST_NAME=$(wget -qO - v4.ident.me)
export SERVICE_ARGS=$SERVICE_ARGS" --tls-san $HOST_NAME"

# 推荐,可选: 裁剪编译了一个不含traefik组件的k3s, 放在这个链接, 如果有traefik组件还要特地删除一下, 一键安装比较麻烦.
export K3S_DOWNLOAD_URL=https://github.com/backrise/k3s/releases/download/v1.29.0%2Bk3s1-no-traefik/k3s # optional, if you don't need traefik

# 安装开始, 创建目录, 下载脚本, 执行.
mkdir -p /opt/k3s && cd /opt/k3s
wget -q -O install.sh https://apiv1.github.io/K8s/k3s/install.sh && chmod +x install.sh

K3S_MODE=server sh install.sh # Server模式, 单机使用K3S
# 安装完成

# 查看
cat /etc/rancher/k3s/k3s.yaml # auth file

# K3S_TOKEN, 也可以在Server启动时用环境变量和参数指定
# https://docs.k3s.io/zh/cli/token
cat /opt/k3s/lib/k3s/server/token

# 可选: 在另一台主机使用Agent模式, 和Server组成多机K3S集群. TOKEN和URL填Server机器的.
# K3S_URL: k3s.yaml里有写
K3S_MODE=agent K3S_TOKEN=xxxxx K3S_URL=xxxxx sh install.sh
```
### [load_k3s_kubeconfig.sh](./load_k3s_kubeconfig.sh)
通过SSH自动读取k3s的yaml文件作为KUBECONFIG的脚本.
```shell
# 下载配置文件
export SERVER=10.10.10.10 # 假设你的主机是这个ip
rm -rf ~/.kube/$SERVER.yaml
load_k3s_kubeconfig.sh $SERVER > ~/.kube/$SERVER.yaml
chmod 400 ~/.kube/$SERVER.yaml

# 要使用这台主机的k3s时, 指定这个环境变量
export KUBECONFIG=~/.kube/$SERVER.yaml

kubectl get nodes # 就可以用了
kubectl --insecure-skip-tls-verify # 跳过tls校验执行某个命令
alias kubectl='kubectl --insecure-skip-tls-verify' # 临时跳过tls校验使用kubectl
```

### deploy_with_registries.sh
一个自动安装脚本的模板, 还配置了registries.yaml 指向私有仓库, 运行Server模式.
* [私有镜像仓库配置](https://docs.k3s.io/zh/installation/private-registry)


```shell
#!/bin/sh

INSTALL_SH_URL=https://apiv1.github.io/K8s/k3s/install.sh
USERNAME=<Your>
PASSWORD=<Your>
IMAGE_REGISTRY=<Image-host-name>
IMAGE_REGISTRY_URL=<Registry-url>

mkdir -p /opt/k3s && cd /opt/k3s

cat <<EOF > registries.yaml
mirrors:
  "${IMAGE_REGISTRY}":
    endpoint:
      - "${IMAGE_REGISTRY_URL}"
configs:
  "${IMAGE_REGISTRY}":
    auth:
      username: $USERNAME
      password: $PASSWORD
EOF

wget -q -O install.sh ${INSTALL_SH_URL} && chmod +x install.sh
K3S_MODE=server sh install.sh

echo . /opt/k3s/.env >> /root/.bashrc

cd -
```

### deploy helm by kubectl
[https://rancher.com/docs/k3s/latest/en/helm/](https://rancher.com/docs/k3s/latest/en/helm/)
一个k8s manifest模板, 描述了如何使用HelmChart组件来安装helm chart
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
```
image: ./lib/k3s/agent/images<br>
manifest: ./lib/k3s/server/manifests<br>
charts: ./lib/k3s/server/static/charts<br>
```

### x509 证书过期, kubectl无法访问解决
```shell
k3s kubectl --insecure-skip-tls-verify=true delete secret k3s-serving -n kube-system
systemctl stop k3s
cd /opt/k3s/
rm lib/k3s/server/tls/dynamic-cert.json
systemctl restart k3s
```

### ~~Remove traefik~~
(Recommend) use no-traefik k3s<br>
ExecStart: --disable traefik --disable traefik-crd<br>
```bash
rm lib/k3s/server/manifests/traefik.yaml

kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd

# or

k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
k3s kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
```