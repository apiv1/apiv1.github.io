[DockerHub](https://hub.docker.com/r/snail007/goproxy)
[文档](https://github.com/snail007/goproxy/blob/master/README_ZH.md)

镜像
```shell
docker pull snail007/goproxy
```

普通一级TCP代理
```
proxy tcp -p ":33080" -T tcp -P "192.168.22.33:22"
```

[compose.yml 例子](./compose.yml)