### build

```bash
docker build . -t apiv1/myvim
docker buildx build . --platform linux/amd64,linux/arm64 --pull --push -t apiv1/myvim
```

### Dood

#### 打包compose镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/myvim:compose
cp ../../compose.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

### 函数式安装myvim

[`安装dood`](../docker/README.md#dood)

[bash/zsh版本](./myvim.envrc)
[powershell版本](./myvim.ps1)

#### 安装richrc

容器内安装(已废弃, 命令内置了)

```shell
mkdir -p ~/.envrc.d
wget -O ~/.envrc.d/.richrc https://apiv1.github.io/Shell/richrc
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
' | NO_TTY=1 dood-run apiv1/myvim:compose -f - run --rm install_richrc
```

可选: myvim服务中安装docker组件
```shell
dood-run apiv1/myvim:compose -f /compose.yml up -d # 若从未启动过环境, 需要先启动一次, 初始化卷数据
wget -O - https://apiv1.github.io/Docker/myenv/install-docker.yml | NO_TTY=1 dood-run apiv1/myvim:compose -f - run --rm --build install-docker
```