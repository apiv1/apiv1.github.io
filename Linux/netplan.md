### 基础
配置文件放在这 -> ```/etc/netplan/``` 文件夹里, 命名规则参考里面原有文件
配置好了后root执行 ```netplan apply```

### 修改跃点数, 提高该网卡优先级
```yaml
  dhcp4-overrides:
      route-metric: 90
```
例子
```yaml
network:
    ethernets:
        ens33:
            dhcp4: true
        ens37:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 90
    version: 2
```

### 连接wifi
查看网卡接口, 找到wifi网卡接口名称
```shell
ls /sys/class/net
```

编辑netplan配置文件, 尖括号的几个地方替换成自己情况
```yaml
network:
  version: 2
  wifis:
    <WIFI Interface>:
      access-points:
        <SSID>:
          password: <PASSWORD>
      dhcp4: true
```