#### 打包compose镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/dood-sshd:compose
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装dood-sshd

[`安装dood`](../docker/README.md#dood)

安装dood-sshd命令

bash

```shell
dood-sshd () {
  test -f compose.override.yml && local RUN_OPT="$RUN_OPT -f ./compose.override.yml" || local RUN_OPT="$RUN_OPT -f /compose.override.yml"
  dood-run apiv1/dood-sshd:compose --project-directory "$PWD"  -f /compose.yml $RUN_OPT $*
}
dood-sshd-config-file () {
  docker rm -f dood-sshd
  docker create --name dood-sshd apiv1/dood-sshd:compose
  docker cp dood-sshd:/compose.override.yml .
  docker rm -f dood-sshd
}
```

powershell

```powershell
function global:dood-sshd () {
  if(Test-Path compose.override.yml) { $RUN_OPT="$RUN_OPT -f ./compose.override.yml" } else { $RUN_OPT="$RUN_OPT -f /compose.override.yml" }
  dood-run apiv1/dood-sshd:compose --project-directory $( docker-path $PWD.Path ) -f /compose.yml $RUN_OPT $($args -join ' ')
}

function global:dood-sshd-config-file() {
  docker rm -f dood-sshd
  docker create --name dood-sshd apiv1/dood-sshd:compose
  docker cp dood-sshd:/compose.override.yml .
  docker rm -f dood-sshd
}
```

#### 使用
```shell
dood-sshd-config-file # 在当前目录生成配置文件 compose.override.yml, 编辑 compose.override.yml 放入配置,密钥,变更项目名称等
dood-sshd up -d # 使用compose命令, 可以启动和停止服务等
```
compose.override.yml 配置可以参考 [这里](./example.md)