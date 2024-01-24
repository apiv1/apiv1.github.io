### build

```shell
export DOCKER_COMPOSE_VERSION=v2.24.0
# apiv1/code-server
docker build . --target docker-compose --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION  -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
docker buildx build . --target docker-compose --platform linux/amd64,linux/arm64 --build-arg DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION --push -t apiv1/docker-compose -t apiv1/docker-compose:$DOCKER_COMPOSE_VERSION
```

### Linux下安装docker-compose (从容器里拷贝到当前目录)

```shell
docker container create --name docker-compose-container apiv1/docker-compose
docker container cp docker-compose-container:/docker-compose .
docker container remove docker-compose-container
```

### 打包配置到镜像 示例

```shell
# 放置临时配置文件, 名字格式为 *compose*.yml
# 下面选一个构建方式构建
docker build . --build-arg DOCKER_COMPOSE_STAGE=apiv1/docker-compose --target docker-compose-pack -t $DOCKER_COMPOSE_IMAGE # legacy
docker buildx build . --build-arg DOCKER_COMPOSE_STAGE=apiv1/docker-compose --target docker-compose-pack --platform linux/amd64,linux/arm64 --push -t $DOCKER_COMPOSE_IMAGE # recommended
rm *compose*.yml # 删除临时配置文件
```

### dind-image

[dind-image.envrc](./dind-image.envrc)
* dind-image: 在容器里使用docker的命令

示例, 安装命令
```shell
# 安装 dind-image
wget -qO $DOCKER_HOME/.envrc.d/dind-image.envrc https://apiv1.github.io/Docker/docker-compose/dind-image.envrc

# 可选安装docker-compose
echo \
'docker-compose () {
  dind-image apiv1/docker-compose $*
}'\
 > $DOCKER_HOME/.envrc.d/docker-compose.envrc
```

#### ~~终端: 使用 docker内的docker-compose~~

bash/zsh

###### 直接mount $PWD, 在$PWD中读取compose.yml

```shell
docker-compose() {
  local PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-$PWD}
  local PUID=$(id -u)
  local PGID=$(id -g)
  test -n "$DOCKER_HOST" -a -z "$DOCKER_SOCK" && export DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  $(which docker) run --rm -it --tmpfs /tmp -v "${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock" -v "$PROJECT_DIRECTORY:$PROJECT_DIRECTORY" -w "$PROJECT_DIRECTORY" -e PUID=$PUID -e PGID=$PGID -e DOCKER_SOCK="${DOCKER_SOCK}" $DOCKER_ARGS apiv1/docker-compose --project-directory "$PROJECT_DIRECTORY" $*
}
```

###### 把compose.yml mount到指定路径，不从$PWD中读取compose.yml

```shell
docker-compose () {
  local PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-$PWD}
  local PUID=$(id -u)
  local PGID=$(id -g)
  local DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_FILE:-$PROJECT_DIRECTORY/compose.yml}
  local DOCKER_ARGS="$DOCKER_ARGS -v $DOCKER_COMPOSE_FILE:/compose.yml"
  test -n "$DOCKER_HOST" -a -z "$DOCKER_SOCK" && export DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  $(which docker) run --rm -it --tmpfs /tmp -v "${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock" -v "$PROJECT_DIRECTORY:$PROJECT_DIRECTORY" -w "$PROJECT_DIRECTORY" -e PUID=$PUID -e PGID=$PGID -e DOCKER_SOCK="${DOCKER_SOCK}" $DOCKER_ARGS apiv1/docker-compose --project-directory "$PROJECT_DIRECTORY" -f /compose.yml $*
}

# (可选, 使用dind-image)
docker-compose () {
  local DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_FILE:-$PROJECT_DIRECTORY/compose.yml}
  local DOCKER_ARGS="$DOCKER_ARGS -v $DOCKER_COMPOSE_FILE:/compose.yml"
  dind-image apiv1/docker-compose $*
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
