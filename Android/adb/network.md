### USB共享网络
```shell
# 开启共享网络
adb shell svc usb setFunctions rndis

# 关闭共享网络
adb shell svc usb setFunctions none
```