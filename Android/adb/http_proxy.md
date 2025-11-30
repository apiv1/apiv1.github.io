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