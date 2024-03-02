### 把k3s安装在数据盘, 但是使用官方安装脚本

执行命令先做一下配置, ```$K3S_HOME```是数据盘文件夹, 放K3S内容.

```shell
K3S_HOME=/opt/k3s
mkdir -p "$K3S_HOME" && cd "$K3S_HOME"
echo \
'disable:
  - traefik
data-dir: '${K3S_HOME}'/data
private-registry: '${K3S_HOME}'/private-registry.yaml
default-local-storage-path: '${K3S_HOME}'/default-local-storage
log: '${K3S_HOME}'/log/output.log
alsologtostderr: true'\
> config.yaml

RANCHER_K3S_DIR=/etc/rancher/k3s
mkdir -p "$RANCHER_K3S_DIR" && ln -sf "$K3S_HOME"/config.yaml "$RANCHER_K3S_DIR"
```

配置完后, 用[快速安装](https://docs.k3s.io/zh/quick-start) 就行.

修改配置
```shell
cd "$K3S_HOME"
vim config.yaml
systemctl restart k3s
```
