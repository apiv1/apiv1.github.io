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
# wifi频段
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
dhcp-option=6,10.1.1.1,119.29.29.29,180.76.76.76
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


#开启dnsmasq
sudo dnsmasq --test #检查语法
sudo systemctl enable dnsmasq --now

# 开启热点
sudo systemctl enable hostapd --now
```

理论上能够连上WIFI上网了.

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