### build

```shell
# apiv1/sshd
docker build .  -t apiv1/sshd --push

docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/sshd
```

### Dood

#### 打包compose镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/dind-sshd:compose
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装dind-sshd

[`安装dood`](../docker/README.md#dood)

安装dind-sshd命令

bash

```shell
dind-sshd () {
  test -f compose.override.yml && local RUN_OPT="$RUN_OPT -f ./compose.override.yml"
  dood-run -e DOCKERD_OPT=$DOCKERD_OPT -e LISTEN_PORT=$LISTEN_PORT apiv1/dind-sshd:compose --project-directory "$PWD"  -f /compose.yml $RUN_OPT $*
}
dind-sshd-config-file () {
  docker rm -f dind-sshd
  docker create --name dind-sshd apiv1/dind-sshd:compose
  docker cp dind-sshd:/compose.override.yml .
  docker rm -f dind-sshd
}
```

powershell

```powershell
function global:dind-sshd () {
  if(Test-Path compose.override.yml) { $RUN_OPT="$RUN_OPT -f ./compose.override.yml" }
  dood-run -e "DOCKERD_OPT='$DOCKERD_OPT'" -e "LISTEN_PORT='$LISTEN_PORT'" apiv1/dind-sshd:compose --project-directory $( docker-path $PWD.Path ) -f /compose.yml $RUN_OPT $($args -join ' ')
}

function global:dind-sshd-config-file() {
  docker rm -f dind-sshd
  docker create --name dind-sshd apiv1/dind-sshd:compose
  docker cp dind-sshd:/compose.override.yml .
  docker rm -f dind-sshd
}
```
