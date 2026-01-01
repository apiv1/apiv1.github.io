### 配置AP子网

```shell
# 前提: 网桥已经建好, 查看网桥
ip link show brlan

# 安装
sudo apt install -y hostapd dnsmasq

# 配置 hostapd ap子网参数
sudo vim /etc/hostapd/hostapd.conf

# 配置 dnsmasq, 用于分配IP和下发网关
sudo vim /etc/dnsmasq.d/dnsmasq.conf
```

### 配置文件

/etc/hostapd/hostapd.conf
```
# 指定网卡
interface=wlan0
# 上面创建的bridge
bridge=brlan
# "g" simply means 2.4GHz band
#hw_mode=g
# a是5Ghz 的wifi
hw_mode=a
# wifi频段, 0自动选择, 2.4g仅支持1-13,5g仅支持149、153、157、161、165
channel=153
# limit the frequencies used to those allowed in the country
ieee80211d=1
# 地区码 这里我填AU
country_code=AU
# 802.11n support
ieee80211n=1
# 802.11ac support
ieee80211ac=1
# QoS support, also required for full speed on 802.11n/ac/ax
wmm_enabled=1

# 1=wpa, 2=wep, 3=both
auth_algs=1
# WPA2 only
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP

# 热点隐藏功能, 0: none, 1: no ssid len=0, 2: no ssid len > 0
ignore_broadcast_ssid=0

# wifi名称
ssid=AAA
#密码
wpa_passphrase=88888888
```
ssid和密码改成自己的

/etc/dnsmasq.d/dnsmasq.conf
```
domain-needed
bogus-priv
clear-on-reload

#上面的docker bridge
interface=brlan
# dhcp范围
dhcp-range=10.1.1.50,10.1.1.150,255.255.255.0,12h
#下发网关
dhcp-option=3,10.1.1.1
#下发dns
dhcp-option=6,10.1.1.1,114.114.114.114,8.8.8.8
```
网关和dns指向的旁路由, 如果旁路由没启动, 网络不通

### 启动服务
```shell
# 查看内核转发
sysctl net.ipv4.ip_forward # 等于1就是已经开了

#开启内核转发(如果没开)

sudo vim /etc/sysctl.conf
#最下面加入
net.ipv4.ip_forward=1
#生效规则
sudo sysctl -p

# 禁用自带的dns服务
sudo systemctl disable --now systemd-resolved  # 禁用开机启动
sudo unlink /etc/resolv.conf               # 删除旧的 DNS 配置（备份可选）
sudo vim /etc/resolv.conf # 因为禁用了systemd-resolved, 所以原来的/etc/resolv.conf 失效了, 要设置新的dns服务器

nameserver 114.114.114.114
nameserver 8.8.8.8

#开启dnsmasq, 并设置开机启动
sudo dnsmasq --test #检查语法
sudo systemctl unmask dnsmasq
sudo systemctl enable  --now dnsmasq

# 一些设置, 如启动遇到问题可以执行
sudo rfkill unblock wifi # 解除无线硬件阻塞

# 开启热点
sudo systemctl unmask hostapd
sudo systemctl start hostapd
```

理论上能够连上WIFI上网了.

#### hostapd 延时开机启动

如果不延时启动, 会影响网卡设置, 导致失效.

在/etc/rc.local里面添加入
```shell
bash -c "sleep 10; systemctl start hostapd" &
```
如果没有此脚本需要设置: [rc.local服务](../../Linux/rc.local开机执行命令.md)

#### 停止服务
```shell
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd
```

#### 重启服务
```shell
sudo systemctl restart dnsmasq
sudo systemctl restart hostapd
```

#### 多个网卡时, 根据网卡mac锁定网卡接口名称
获取设备信息
```shell
# 查看无线网卡的 MAC 地址和总线路径
ip link show
udevadm info -a /sys/class/net/wlan1
udevadm info -a /sys/class/net/wlan2
```
创建 udev 规则文件
```shell
sudo vim /etc/udev/rules.d/10-persistent-net.rules
```
添加规则（示例）
```
# 通过 MAC 地址绑定名称（替换为实际值）
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="wlan1"
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="11:22:33:44:55:66", NAME="wlan2"
```
应用规则并重启
```shell
sudo udevadm control --reload
sudo reboot
```