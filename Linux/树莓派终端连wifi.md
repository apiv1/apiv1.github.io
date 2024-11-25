### 查看WIFI
```shell
# 查看无线网卡
ip addr

NETCARD=wlan0

# 搜索
sudo iwlist $NETCARD scan | less

sudo iwlist $NETCARD scan | grep ESSID
```
### 树莓派设置
```shell
sudo raspi-config
# 1. System Options
# S1 Wireless Lan, 输入SSID/密码
```

### ~~手动设置~~

#### 配置WIFI
/etc/wpa_supplicant/wpa_supplicant.conf
```conf
network={ ssid="你的Wi-Fi名称" psk="你的Wi-Fi密码" key_mgmt=WPA-PSK }
```

#### 重启网卡
```shell
sudo wpa_cli -i wlan0 reconfigure
# 或者
sudo ifconfig wlan0 down
sudo ifconfig wlan0 up
```