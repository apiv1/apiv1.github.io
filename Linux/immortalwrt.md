[选择固件版本](https://firmware-selector.immortalwrt.org/)
[旁路由设置](https://liuxs.pro/blog/%E6%A0%91%E8%8E%93%E6%B4%BEimmortalwrt%E6%97%81%E8%B7%AF%E7%94%B1%E8%AE%BE%E7%BD%AE/)

[Docker软路由+无线AP](../Docker/immortalwrt/README.md)

### openwrt插件

#### Passwall
* 透明代理无法生效
  解决:
  ```shell
    opkg update
    opkg install iptables
    /etc/init.d/passwall restart
  ```

#### Easytier
* 通过easytier网络无法访问管理页面和远程登录
  解决:
  ```
  网络->防火墙->常规设置->区域
  添加一条记录:
    常规设置: 涵盖的网络, 全选
    高级设置: 涵盖的设备, 全选
    入站出站转发: 全接受
  保存并应用
  也可以按照自己需要来收紧权限
  ```

### docker network host模式使用immortalwrt
设备使用wifi联网, 用网线给电脑提供单口路由器功能. 可用于wol唤醒电脑

软路由里需要配置dhcp, 让电脑网口能拿到ip

网卡数据转发
```shell
if_forward() {
  IF_IN=$1
  IF_OUT=$2

  iptables -t nat -A POSTROUTING -o $IF_OUT -j MASQUERADE
  iptables -A FORWARD -i $IF_IN -o $IF_OUT -j ACCEPT
  iptables -A FORWARD -i $IF_OUT -o $IF_IN -m state --state RELATED,ESTABLISHED -j ACCEPT
}

if_forward eth0 wlan0
```

防火墙关闭
```shell
/etc/init.d/firewall stop
/etc/init.d/firewall disable
```

wol唤醒电脑, dhcp配置的网段是192.168.1.0/24. 指定ip强制使用特定网卡发wol包.
```shell
MAC='01:02:03:04:05:06'
BORADCAST_IP=192.168.1.255
IF_IN=eth0

sudo ip addr add $BORADCAST_IP dev $IF_IN
wakeonlan -i $BORADCAST_IP $MAC
sudo ip addr del $BORADCAST_IP dev $IF_IN
```

### eth0 改成 LAN 口 / 改回 WAN 口

#### A. eth0 改成 LAN 口

1. 网络 → 接口 → **接口** → 删掉 `ETH0`
2. 网络 → 接口 → **设备** → `br-lan` → 配置 → **网桥端口** 勾上 `eth0` → 保存并应用
3. 网络 → 防火墙 → **区域** → `wan` → 编辑 → **覆盖的网络 / 覆盖的设备** 里去掉 `eth0` → 保存并应用

> 顺序别反：先删接口再进网桥，否则 LuCI 会提示设备被占用。

#### B. 改回 eth0 = WAN

1. 网络 → 接口 → **设备** → `br-lan` → 配置 → **网桥端口** 取消勾选 `eth0` → 保存并应用
2. 网络 → 接口 → **接口** → 添加新接口：名称 `eth0`、设备 `eth0`、协议选 `DHCP 客户端` → 保存并应用
3. 网络 → 防火墙 → **区域** → `wan` → 编辑 → **覆盖的网络 / 覆盖的设备** 加上 `eth0` → 保存并应用

> LAN 口不用建接口（br-lan 管）；WAN 口必须建，不然拿不到 IP。