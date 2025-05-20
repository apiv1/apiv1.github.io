### 创建网桥

```shell
docker network create -d bridge --subnet=10.1.1.0/24 --gateway=10.1.1.254 -o "com.docker.network.bridge.name=brlan" brlan
```

### 创建软路由

#### 启动
```shell
docker run -d --restart always --name immortalwrt --network brlan --privileged -v immortalwrt-config:/etc/config -v /lib/modules:/lib/modules --entrypoint /sbin/init immortalwrt:current
```

### 创建macvlan地址（如果可用）
***可用于设置旁路由模式***

参考: [docker中创建macvlan网络](../../Linux/macvlan.md#docker中创建-macvlan网络)

这里就算不设置--subnet和--gateway也不影响

##### 暂时连接方式
```shell
IP=192.168.0.211
docker network connect immortalwrt macvlan-network --ip $IP
```
宿主机无法和容器通过macvlan互通，需要[额外设置](../../Linux/macvlan.md#创建macvlan网络). 局域网其他机器能和容器机直接互通.
如果使用macvlan旁路由功能，还需要在路由器的 网络->设备 里添加eth1网桥（新增的macvlan）， 在网络->接口里添加新接口，使用网桥。

#### 旁路由设置

* ip设置为10.1.1.1, 网关是10.1.1.254

/etc/config/network
```
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth0'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '10.1.1.1'
	option gateway '10.1.1.254'
	option netmask '255.255.255.0'
	option ip6assign '60'
	list dns '10.1.1.254'
	list dns '114.114.114.114'
	list dns '8.8.8.8
```

执行命令
```shell
docker exec -it immortalwrt sh
vi /etc/config/network # 设置上面的文件
/etc/init.d/network restart # 重启网络
```

#### 旁路由规则设置
路由设置
```shell
iptables -t nat -A POSTROUTING -o br-lan -j MASQUERADE
```
***等价于***```后台管理->网络->防火墙->区域->lan 勾上 IP动态伪装```
如果不设置这个, 旁路由没开启NAT上不了网.

##### 用旁路由通过easytier转发到其他网段
需要对easytier的网卡(这里是tun0)配置动态伪装,命令如下
```shell
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
```
***等价于***, 开启IP动态伪装时, 在```后台管理->网络->防火墙->区域->区域设置->涵盖的设备```加上tun0网卡。

#### 软路由配置
```shell
# 更新到镜像
docker commit immortalwrt immortalwrt:current

# 还原初始配置
docker tag immortalwrt:base immortalwrt:current
```

#### 删除软路由
```shell
docker rm -f immortalwrt
```

#### 删除网桥
```shell
docker network rm brlan
```