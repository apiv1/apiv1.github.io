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

[bash/zsh版本](./myvim.envrc)
[powershell版本](./myvim.ps1)

#### 安装richrc

容器内安装

```shell
mkdir -p /root/.envrc.d
wget -O /root/.envrc.d/.richrc https://apiv1.github.io/Shell/richrc
```

外部安装(已废弃, 因为容器内也装wget了)

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
' | NO_TTY=1 dind-run apiv1/myvim:dind -f - run --rm install_richrc
```

可选: myvim服务中安装dind组件
[`容器环境内安装dind`](../dind/README.md#在其他的compose-project中安装docker组件,-实现dind)