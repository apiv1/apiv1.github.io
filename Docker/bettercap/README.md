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
iptables -t nat -X HTTPS_REDIREC
```

## bettercap

### proxy.js
仅仅打印req/resp

```javascript
function onLoad() {
    log_info("=== 脚本加载成功 ===");
}

// 处理HTTP/HTTPS请求
function onRequest(req, res) {
    var client_ip = req.Client.IP;
    var method = req.Method;
    var hostname = req.Hostname;
    var path = req.Path;

    // 先读取request body
    req.ReadBody();

    var requestInfo = "\n[PROXY REQUEST]\n" +
                      "Client IP: " + client_ip + "\n" +
                      "Method: " + method + "\n" +
                      "Host: " + hostname + "\n" +
                      "Path: " + path + "\n" +
                      "Query: " + req.Query + "\n" +
                      "=== Request Headers ===\n" +
                      req.Headers;

    if (req.Body && req.Body.length > 0) {
        var bodyPreview = req.Body.length > 100 ? req.Body.substring(0, 100) + "..." : req.Body;
        requestInfo += "\n=== Request Body (" + req.Body.length + " bytes) ===\n" + bodyPreview;
    }

    log_info(requestInfo);

    return req;
}

// 处理HTTP/HTTPS响应
function onResponse(req, res) {
    var client_ip = req.Client.IP;
    var hostname = req.Hostname;
    var status = res.Status;

    // 先读取response body
    res.ReadBody();

    var responseInfo = "\n[PROXY RESPONSE]\n" +
                       "Client IP: " + client_ip + "\n" +
                       "Status: " + status + "\n" +
                       "Host: " + hostname + "\n" +
                       "Content-Type: " + res.ContentType + "\n" +
                       "=== Response Headers ===\n" +
                       res.Headers;

    if (res.Body && res.Body.length > 0) {
        var bodyPreview = res.Body.length > 100 ? res.Body.substring(0, 100) + "..." : res.Body;
        responseInfo += "\n=== Response Body (" + res.Body.length + " bytes) ===\n" + bodyPreview;
    }

    log_info(responseInfo);

    return res;
}
```

### proxy.cap

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

请求和响应将会流经```proxy.js```的回调代码。
```shell
sudo bettercap -caplet proxy.cap
```

### Docker compose执行

[compose.yml](./compose.yml)

```shell
docker compose run --rm bettercap -c "/app/bettercap -caplet proxy.cap"
```