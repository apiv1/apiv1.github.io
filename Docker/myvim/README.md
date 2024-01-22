### build

```bash
docker build . -t apiv1/myvim
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/myvim
```

### dind

#### 打包dind镜像

```shell
# 准备打包
export DOCKER_COMPOSE_FILE=$PWD/../../compose.yml
export DOCKER_COMPOSE_IMAGE=apiv1/myvim:dind
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 使用myvim dind

执行: [`使用打包镜像`](../docker-compose/README.md#compose-image-使用镜像)

```shell
myvim () {
  compose-image apiv1/myvim:dind --project-name myvim $*
}
```

以上使用配置贴在终端里或者放```.bashrc/.zshrc```里