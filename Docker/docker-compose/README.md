### build

```shell
export DOCKER_COMPOSE_VERSION=v2.24.0
# apiv1/code-server
docker build . --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION  -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION --push -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
```

### 打包配置到镜像 示例

```shell
export DOCKER_COMPOSE_IMAGE=<docker-compose-image> # 指定镜像名称
cp $DOCKER_COMPOSE_FILE compose.yml
docker build . -f ./Dockerfile.compose -t $DOCKER_COMPOSE_IMAGE
docker buildx build . -f ./Dockerfile.compose --platform linux/amd64,linux/arm64 --push -t $DOCKER_COMPOSE_IMAGE
rm compose.yml
```

### compose-image 使用镜像

##### 可以使用函数,也可以把执行部分的镜像变量写死, 直接运行

```shell
compose-image () {
  if test "$#" -lt 1; then
    echo "usage: <COMPOSE_IMAGE> [ARG1] [ARG2] ..."
    return 1
  fi
  DOCKER_COMPOSE_IMAGE=$1
  shift 1

  PUID=$(id -u)
  PGID=$(id -g)
  test $PUID -eq 0 || export SUDO=sudo
  test -n "$DOCKER_HOST" -a -z "$DOCKER_SOCK" && export DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  $SUDO $(which docker) run --rm -it -v "${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock" -v "$PWD:$PWD" -w "$PWD" -e DOCKER_SOCK="${DOCKER_SOCK}" -e PUID=$PUID -e PGID=$PGID $DOCKER_COMPOSE_IMAGE --project-directory "$PWD" $*
}
```

Linux下安装docker-compose (从容器里拷贝到当前目录)

```shell
docker container create --name docker-compose-container apiv1/docker-compose
docker container cp docker-compose-container:/docker-compose .
docker contaienr remove docker-compose-container
```

#### 终端: 使用 docker内的docker-compose

bash/zsh

###### 直接mount $PWD, 在$PWD中读取compose.yml

```shell
docker-compose() {
  PUID=$(id -u)
  PGID=$(id -g)
  test $PUID -eq 0 || export SUDO=sudo
  test -n "$DOCKER_HOST" -a -z "$DOCKER_SOCK" && export DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  $SUDO $(which docker) run --rm -it -v "${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock" -v "$PWD:$PWD" -w "$PWD" -e PUID=$PUID -e PGID=$PGID -e DOCKER_SOCK="${DOCKER_SOCK}" apiv1/docker-compose $*
}
```

###### 把compose.yml mount到指定路径，不从$PWD中读取compose.yml

```shell
docker-compose () {
  PUID=$(id -u)
  PGID=$(id -g)
  test $PUID -eq 0 || export SUDO=sudo
  DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_FILE:-$PWD/compose.yml}
  test -n "$DOCKER_HOST" -a -z "$DOCKER_SOCK" && export DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  $SUDO $(which docker) run --rm -it -v "${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock" -v "$PWD:$PWD" -w "$PWD" -v $DOCKER_COMPOSE_FILE:/compose.yml -e PUID=$PUID -e PGID=$PGID -e DOCKER_SOCK="${DOCKER_SOCK}" apiv1/docker-compose -f /compose.yml --project-directory "$PWD" $*
}
```

Powershell

```powershell
function docker-compose() {
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "${PWD}:${PWD}" -w "${PWD}" apiv1/docker-compose $args
}
```

Windows Powershell

```powershell
function docker-compose() {
  docker run --rm -it -e COMPOSE_CONVERT_WINDOWS_PATHS=1 -v //var/run/docker.sock:/var/run/docker.sock -v "${PWD}:/workspace" -w "/workspace" apiv1/docker-compose $args
}
```

#### 参考

------
[Windows下绑定docker-socket](https://stackoverflow.com/questions/36765138/bind-to-docker-socket-on-windows)
