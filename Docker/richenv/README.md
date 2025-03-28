### Build
core
```shell
docker buildx build . --platform linux/amd64,linux/arm64 --pull --push -t apiv1/richenv:core --target core

# chrome (only amd64)
docker buildx build . --build-arg STAGE_REMOTE_DESKTOP=apiv1/remote-desktop:chrome --platform linux/amd64 --pull --push -t apiv1/richenv:core-with-chrome --target core
```

full(with dockerd, code-server)
```shell
docker buildx build . --build-arg STAGE_CORE=apiv1/richenv:core --platform linux/amd64,linux/arm64 --pull --push -t apiv1/richenv:full --target full

# chrome (only amd64)
docker buildx build . --build-arg STAGE_CORE=apiv1/richenv:core-with-chrome --platform linux/amd64 --pull --push -t apiv1/richenv:full-with-chrome --target full
```

custom(example: add dockerd)
```shell
export DOCKERFILE_DOCKERD='
ARG STAGE_CORE
FROM ${STAGE_CORE}
# dockerd service
COPY --from=apiv1/dockerd /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/docker-compose /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/docker-buildx /usr/local/bin/* /usr/local/bin/
COPY --chmod=0755 init.d/dockerd.service.sh /init.d/
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
  ln -s $(which docker-compose) /usr/local/lib/docker/cli-plugins/ && \
  ln -s $(which docker-buildx) /usr/local/lib/docker/cli-plugins/
'

printf "$DOCKERFILE_DOCKERD" | docker buildx build -f - . --build-arg STAGE_CORE=apiv1/richenv:core --platform linux/amd64,linux/arm64 --pull --push -t apiv1/richenv:dockerd

# chrome (only amd64)
printf "$DOCKERFILE_DOCKERD" | docker buildx build -f - . --build-arg STAGE_CORE=apiv1/richenv:core-with-chrome --platform linux/amd64 --pull --push -t apiv1/richenv:dockerd-with-chrome
```

### Run

可选: [配置macvlan网络, 使用桥接, 获得局域网独立ip](../dind-sshd/example.md)

```shell
# 使用.compose.yml, 把内容复制进去
# 配置macvlan网络 则需要复制compose.override.yml, 且可以设置macvlan的ip
vim compose.yml

# 配置.compose.yml中的环境变量
vim .env

# 启动
docker compose up -d
```