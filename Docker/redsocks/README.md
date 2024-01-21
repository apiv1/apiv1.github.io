build
```shell
docker build . -t apiv1/redsocks
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/redsocks
```

run
```shell
# docker内部网络将连接重定向到`$SOCKS5_PROXY_HOST:$SOCKS5_PROXY_PORT`进行代理, 需要先有一个socks5代理
docker run --privileged=true --net=host -d --name redsocks apiv1/redsocks $SOCKS5_PROXY_HOST $SOCKS5_PROXY_PORT

# 可选: 启动服务后自动设置iptables
docker run --privileged=true -e START_FW=1 --net=host -d --name redsocks apiv1/redsocks $SOCKS5_PROXY_HOST $SOCKS5_PROXY_PORT

# IPTABLE_ARGS='-i docker0' iptables 默认影响docker0网卡, 可以通过-e 设置环境变量修改iptables参数
docker exec redsocks redsocks-fw.sh start

# 恢复IPTABLES, 停用服务
docker exec redsocks redsocks-fw.sh stop
docker rm -f redsocks
```


docker-compose
```shell
# .env.example 复制为 .env, 使用.env中环境变量参数设置代理
# 启动服务
docker-compose up -d

# 运行后需手动开启iptables设置, 启用代理
docker-compose exec redsocks redsocks-fw.sh start

# 退出时需先运行命令恢复iptables, 否则网络无法正常使用
docker-compose exec redsocks redsocks-fw.sh stop
```

验证代理生效
```shell
docker run --rm -it rancher/curl ipinfo.io
docker run --rm -it netdata/wget wget -O - ipinfo.io
```