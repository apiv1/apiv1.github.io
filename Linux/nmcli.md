### 创建持久化网口
```shell
nmcli connection del brlan
nmcli connection add type bridge con-name brlan ifname brlan ip4 10.1.1.0/24 gw4 10.1.1.254
nmcli connection up brlan
```