### 创建持久化网口
```shell
nmcli connection del brlan
nmcli connection add type bridge con-name brlan ifname brlan ip4 10.1.1.0/24 gw4 10.1.1.254
nmcli connection up brlan
```

### 查看可用Wifi
root权限可以看到更详细的信息
```shell
nmcli device wifi list
nmcli -f IN-USE,SSID,SIGNAL dev wifi
nmcli dev wifi
```

### 设置Wifi
```shell
export SSID="MyWifi" WIFI_PASSWORD="mypassword"

nmcli connection add type wifi con-name "$SSID" ifname wlan0 ssid "$SSID" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$WIFI_PASSWORD" connection.autoconnect yes
```

### 修改现有连接的metric
```shell
nmcli connection show # 查看connection名称/UUID

CONNECTION="xxx" # 根据显示设置对应connection

nmcli connection down $CONNECTION
nmcli connection modify $CONNECTION ipv4.route-metric 100
nmcli connection up $CONNECTION
```

### Wifi启停
```shell
sudo nmcli device up wlan0
sudo nmcli device down wlan0
```