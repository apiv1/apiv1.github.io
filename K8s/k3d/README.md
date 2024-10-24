### [(可选) 安装Docker](../../Docker/dockerd/README.md)

### [(可选) 配置远程docker](../../Tools/远程Docker.md)

### 下载[k3d](https://github.com/k3d-io/k3d/releases), 若使用远程Docker, 本机安装k3d即可, 单文件放进PATH目录

### create cluster
创建k3s集群
```shell
vim registries.yaml # 配镜像仓库, 要不国内难拉下来镜像
k3d cluster create --registry-config registries.yaml
```
参考: [registries.yaml](../k3s/README.md#private-registry-for-k3s-server)
执行完了后会自动配置```~/.kube/config```指向新建的cluster

### add port
添加端口映射
```shell
k3d node ls
# 默认cluster名字是default, 所以node名字 k3d-k3s-default-serverlb
k3d node edit k3d-k3s-default-serverlb --port-add 1000:1000
```