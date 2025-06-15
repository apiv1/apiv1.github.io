### 创建持久化网口
```shell
nmcli connection del brlan
nmcli connection add type bridge con-name brlan ifname brlan ip4 10.1.1.0/24 gw4 10.1.1.254
nmcli connection up brlan
```

### 查看可用Wifi
```shell
nmcli device wifi list
```

### 设置Wifi
```shell
export SSID="MyWifi" WIFI_PASSWORD="mypassword"

nmcli connection add type wifi con-name "$SSID" ifname wlan0 ssid "$SSID" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$WIFI_PASSWORD" connection.autoconnect yes
```