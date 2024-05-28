### netsh 设置

* 需要使用管理员shell

```powershell
# 列出所有网络接口
netsh interface ipv4 show interfaces

# 这里是网络接口名字
$INTERFACE='以太网'

# 给网络接口设置mtu值
# 根据 列出的网络接口 设置对应的接口名字
# store=persistent 意思是持久化设置, 重启后还生效
netsh interface ipv4 set subinterface "$INTERFACE" mtu=1400 store=persistent

# 设置动态获取IP地址和和自动获取DNS
netsh interface ip set address name="$INTERFACE" source=dhcp
netsh interface ip set dns name="$INTERFACE" source=dhcp

# 设置固定IP和DNS
netsh interface ip set address name="$INTERFACE" source=static addr=192.168.0.110 mask=255.255.255.0 gateway=192.168.0.1
netsh interface ip set dns name="$INTERFACE" source=static addr=202.106.196.115 register=primary

```