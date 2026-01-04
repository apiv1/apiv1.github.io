### 设置代理
http_proxy同时处理http和https流量
```shell
adb shell settings put global http_proxy 192.168.1.100:8080

adb shell settings put global http_proxy 192.168.1.100 8080
```

### 读取代理
```shell
adb shell settings get global http_proxy
```

### 取消代理
几种命令都可以
```shell
adb shell settings put global http_proxy :0

adb shell settings put global http_proxy ""

adb shell settings delete global http_proxy
```

### 代理拆分字段的设置， 比较底层（删除时需重启才生效）
```shell
# 设置
adb shell settings put global global_http_proxy_host 192.168.1.100
adb shell settings put global global_http_proxy_port 8080
adb shell settings put global global_http_proxy_username user
adb shell settings put global global_http_proxy_password pass

# 读取
adb shell settings get global global_http_proxy_host
adb shell settings get global global_http_proxy_port
adb shell settings get global global_http_proxy_username
adb shell settings get global global_http_proxy_password

# 删除
adb shell settings delete global global_http_proxy_host
adb shell settings delete global global_http_proxy_port
adb shell settings delete global global_http_proxy_username
adb shell settings delete global global_http_proxy_password
```