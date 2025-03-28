[DockerHub](https://hub.docker.com/r/snail007/goproxy)
[文档](https://github.com/snail007/goproxy/blob/master/README_ZH.md)

镜像
```shell
docker pull snail007/goproxy
docker pull snail007/goproxy:arm64-v13.4 # for arm

docker run --rm -it snail007/goproxy --network host tcp -p ":33080" -T tcp -P "192.168.22.33:22"
```

普通一级TCP代理
```
proxy tcp -p ":33080" -T tcp -P "192.168.22.33:22"
```

[compose.yml 例子](./compose.yml)