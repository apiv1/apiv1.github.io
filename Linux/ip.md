### 换mac地址(临时)

[mac地址生成](https://it-tools.tech/mac-address-generator)
命令生成的mac地址可能非法, 无法使用.

```shell
random_mac() {
  echo $RANDOM | md5sum | sed 's/../&:/g' | cut -c 1-17
}

FAKE_MAC=$(random_mac)

sudo ip link set dev eth0 down && \
sudo ip link set dev eth0 address $FAKE_MAC && \
sudo ip link set dev eth0 up && \
echo "MAC：" $(ip link show eth0 | grep link/ether)
```

### 添加删除ip
```shell
sudo ip addr add 192.168.1.255/24 dev eth0
sudo ip addr del 192.168.1.255/24 dev eth0
```

### 路由器关掉DHCP的配置
设备要联网需要配置ip和默认网关
```shell
ip addr add 192.168.1.2/24 dev eth0
route add default gw 192.168.1.1
```

### ip only
```shell
ip addr show eth0 | awk -F'[/ ]+' '/inet / {print $3}'
```