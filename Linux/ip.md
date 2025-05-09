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