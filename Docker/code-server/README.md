### build

```bash
# https://github.com/coder/code-server/releases
export CODE_SERVER_VERSION=4.20.0
# apiv1/code-server
docker build . --target code-server --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION  -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION
docker buildx build . --target code-server --platform linux/amd64,linux/arm64 --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION --push -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION

# apiv1/code-server:daemon
docker build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION
docker buildx build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION --platform linux/amd64,linux/arm64 --push -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION
```

### hashed password

```shell
# in zsh (echo -n without '\n')
echo -n "thisismypassword" | npx argon2-cli -e

# in docker(recommend)
docker run --rm -it leplusorg/hash sh -c 'echo -n thisismypassword | argon2 thisissalt -e'

# function
hashed-passwd () {
  local SALT=${SALT:-thisissalt}
  /bin/echo -n 'password:' && read -s PASSWORD && /bin/echo 'saved to env HASHED_PASSWORD'
  export HASHED_PASSWORD=$(docker run --rm -it leplusorg/hash sh -c 'echo -n '$PASSWORD' | argon2 '$SALT' -e')
}
```

### dind

#### 打包dind镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/code-server:dind
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装code-server

[`安装docker-dind`](../docker-compose/README.md#docker-dind)

安装code-server命令

bash
```shell
cd $DOCKER_HOME/.envrc.d
echo \
'code-server () {
  docker-dind -e NETWORK_MODE=$NETWORK_MODE -e PROXY_DOMAIN=$PROXY_DOMAIN -e LISTEN_ADDR=$LISTEN_ADDR -e CODE_SERVER_BIND_ADDR=$CODE_SERVER_BIND_ADDR -e PASSWORD=$PASSWORD -e HASHED_PASSWORD=$HASHED_PASSWORD apiv1/code-server:dind --project-directory "$PWD" -f /compose.yml $*
}'\
> code-server.envrc
cd -
```

powershell
```powershell
function code-server () {
  docker-dind -e "NETWORK_MODE='$NETWORK_MODE'" -e "PROXY_DOMAIN='$PROXY_DOMAIN'" -e "LISTEN_ADDR='$LISTEN_ADDR'" -e "CODE_SERVER_BIND_ADDR='$CODE_SERVER_BIND_ADDR'" -e "PASSWORD='$PASSWORD'" -e "HASHED_PASSWORD='$HASHED_PASSWORD'" apiv1/code-server:dind --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}
```
可选: code-server服务中安装docker组件
```shell
wget -O - https://apiv1.github.io/Docker/code-server/install-docker.yml | NO_TTY=1 docker-dind apiv1/code-server:dind -f - run --rm --build install-docker
```