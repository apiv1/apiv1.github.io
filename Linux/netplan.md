修改跃点数, 提高该网卡优先级
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