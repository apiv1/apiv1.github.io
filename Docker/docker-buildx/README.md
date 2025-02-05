### build

```shell
export DOCKER_BUILDX_VERSION=v0.13.1
# apiv1/docker-buildx
docker build . --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION  -t apiv1/docker-buildx -t apiv1/docker-buildx:$DOCKER_BUILDX_VERSION

docker buildx build . --platform linux/amd64,linux/arm64 --build-arg DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION --pull --push -t apiv1/docker-buildx -t apiv1/docker-buildx:$DOCKER_BUILDX_VERSION
```

### Linux下安装docker-buildx (从容器里拷贝到当前目录)

```shell
# 可选 需要 root 权限
sudo -s

# 可选 安装到 /bin, 或者自己设置的路径
cd /bin

docker container create --pull always --name buildx-container apiv1/docker-buildx
docker container cp buildx-container:/usr/local/bin/docker-buildx .
docker container remove buildx-container

# 默认 装在system目录
type docker-buildx && mkdir -p /usr/local/lib/docker/cli-plugins && ln -s $(which docker-buildx) /usr/local/lib/docker/cli-plugins/

# 可选 装在user目录
type docker-buildx && ln -s $(which docker-buildx) ~/.docker/cli-plugins/
```

### 函数式安装docker-buildx
[`安装dood`](../docker/README.md#dood)