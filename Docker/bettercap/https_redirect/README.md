## iptables 重定向

在子网网关机器上配置

```shell
# 配置
PROXY_HOST=192.168.0.100
PROXY_HTTP_PORT=8080
PROXY_HTTPS_PORT=8083
NET_INTERFACE=eth0
IPTABLES_PARAMS="-i ${NET_INTERFACE}"

# 设置重定向
iptables -t nat -N HTTPS_REDIRECT
iptables -t nat -A PREROUTING -j HTTPS_REDIRECT
iptables -t nat -A HTTPS_REDIRECT -p tcp --dport 443 -j DNAT --to-destination ${PROXY_HOST}:${PROXY_HTTPS_PORT} ${IPTABLES_PARAMS}
iptables -t nat -A HTTPS_REDIRECT -p tcp --dport 80 -j DNAT --to-destination ${PROXY_HOST}:${PROXY_HTTP_PORT} ${IPTABLES_PARAMS}
iptables -t nat -A POSTROUTING -o "$NET_INTERFACE" -j MASQUERADE

# 删除重定向
iptables -t nat -D POSTROUTING -o "$NET_INTERFACE" -j MASQUERADE
iptables -t nat -D PREROUTING -j HTTPS_REDIRECT
iptables -t nat -F HTTPS_REDIRECT
iptables -t nat -X HTTPS_REDIRECT
```

## proxy.cap

[proxy.js](./proxy.js): 仅仅打印req/resp

不使用 ```https.proxy.redirect```来重定向连接，已经在上面自己手动配置了iptables

```
set https.proxy.script proxy.js
set https.proxy.sslstrip true
set https.proxy.redirect false
set https.proxy.port 8083
set https.proxy.address 0.0.0.0
set https.proxy.certificate ./cert/ca.crt
set https.proxy.key ./cert/ca.key
set http.proxy.script proxy.js
set http.proxy.redirect false
set http.proxy.port 8080
set http.proxy.address 0.0.0.0
https.proxy on
http.proxy on
```

### 执行

请求和响应将会流经```proxy.js```的回调代码。 需要权限运行bettercap
```shell
bettercap -caplet proxy.cap
```