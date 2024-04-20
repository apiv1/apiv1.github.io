### build

```bash
# https://github.com/coder/code-server/releases
export CODE_SERVER_VERSION=4.23.0
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

### Dood

#### 打包compose镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/code-server:compose
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装code-server

[`安装dood`](../docker/README.md#dood)

安装code-server命令

[bash](./code-server.envrc)

[powershell](./code-server.ps1)

可选: code-server服务中安装docker组件
```shell
dood-run apiv1/code-server:compose -f /compose.yml up -d # 若从未启动过环境, 需要先启动一次, 初始化卷数据
wget -O - https://apiv1.github.io/Docker/myenv/install-docker.yml | NO_TTY=1 dood-run apiv1/code-server:compose -f - run --rm --build install-docker
```