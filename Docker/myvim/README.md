### build

```bash
docker build . -t apiv1/myvim
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/myvim
```

### dind

#### 打包dind镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/myvim:dind
cp ../../compose.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

### 函数式安装myvim
[`安装docker-dind`](../dind/README.md#docker-dind)

```shell
myvim () {
  docker-dind apiv1/myvim:dind $*
}
```

#### 安装richrc
```shell
echo '
name: myvim
services:
  install_richrc:
    image: netdata/wget
    command: |
      sh -c "
        mkdir -p /dst/root/.envrc.d
        wget -O /dst/root/.envrc.d/.richrc https://apiv1.github.io/Shell/richrc
      "
    volumes:
      - home:/dst/root
    network_mode: host
volumes:
  home:
' | NO_TTY=1 docker-dind apiv1/myvim:dind -f - run --rm install_richrc
```