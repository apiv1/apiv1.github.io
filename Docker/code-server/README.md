### build

```bash
export CODE_SERVER_VERSION=4.20.0
# apiv1/code-server
docker build . --target code-server --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION  -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION
docker buildx build . --target code-server --platform linux/amd64,linux/arm64 --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION --push -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION

# apiv1/code-server:daemon
docker build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION
docker buildx build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION --platform linux/amd64,linux/arm64 --push -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION

# apiv1/code-server:daemon-dind
docker build . --target daemon-dind --build-arg CODE_SERVER_DAEMON_IMAGE=apiv1/code-server:daemon-$CODE_SERVER_VERSION -t apiv1/code-server:daemon-dind -t apiv1/code-server:daemon-dind-$CODE_SERVER_VERSION
docker buildx build . --target daemon-dind --build-arg CODE_SERVER_DAEMON_IMAGE=apiv1/code-server:daemon-$CODE_SERVER_VERSION --platform linux/amd64,linux/arm64 --push -t apiv1/code-server:daemon-dind -t apiv1/code-server:daemon-dind-$CODE_SERVER_VERSION
```

### dind

#### 打包dind镜像

```shell
# 生成 .dind.compose.yml
yq eval-all 'select(fileIndex == 0) *+ select(fileIndex == 1)' compose.yml dind.yml > .dind.compose.yml

# 拷贝到../docker-compose, 准备打包
cp .dind.compose.yml ../docker-compose
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包)

```shell
# 镜像名字是这个
export DOCKER_COMPOSE_IMAGE=apiv1/code-server:dind
```

#### 使用code-server dind

执行: [`使用打包镜像`](../docker-compose/README.md#compose-image)

```shell
code-server () {
  compose-image apiv1/code-server:dind $*
}
```

以上使用配置贴在终端里或者放```.bashrc/.zshrc```里

### hashed password

```shell
# in zsh (echo -n without '\n')
echo -n "thisismypassword" | npx argon2-cli -e

# in docker(recommend)
docker run --rm -it leplusorg/hash sh -c 'echo -n thisismypassword | argon2 thisissalt -e'
```
