build
```shell
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/redsocks
```

run
```shell
# IPTABLE_ARGS='-i docker0' iptables 默认影响docker0网卡, 可以通过-e 设置环境变量修改iptables参数
# docker内部网络将连接重定向到`$HTTP_PROXY_HOST:$HTTP_PROXY_PORT`进行代理, 需要先有一个http代理
docker run --privileged=true --net=host -d --name redsocks apiv1/redsocks $HTTP_PROXY_HOST $HTTP_PROXY_PORT
```