### Macvlan的配置

#### 创建macvlan网络

```shell
# 假定ip段为 192.168.0.0/24, 网关是192.168.0.1, 网络接口eth0
# 使用时需要替换这些变量值为自己的实际情况
SUB_NET=192.168.0.0/24
INTERFACE=eth0
MACVLAN_NAME=macvlan-network

# 宿主机无法和容器互通需要配置macvlan
ip link del $MACVLAN_NAME # 可选: 重设需要先删掉link
ip link add $MACVLAN_NAME link $INTERFACE type macvlan mode bridge

IP=192.168.0.100 # 宿主机在局域网里的IP
ip addr del $IP dev $MACVLAN_NAME
ip addr add $IP dev $MACVLAN_NAME # 绑定一个可供子网内容器通讯宿主机的IP, 这里直接复用宿主机在局域网里的IP
ip link set $MACVLAN_NAME up

ip route add $SUB_NET dev $MACVLAN_NAME # 路由: 宿主机->容器子网
```

#### docker中创建 macvlan网络

```shell
# 假定ip段为 192.168.0.0/24, 网关是192.168.0.1, 网络接口eth0
# 使用时需要替换这些变量值为自己的实际情况
SUB_NET=192.168.0.0/24
INTERFACE=eth0
MACVLAN_NAME=macvlan-network

# 创建 docker network
GATEWAY=192.168.0.1
docker network create -d macvlan --subnet=$SUB_NET --gateway=$GATEWAY -o parent=$INTERFACE $MACVLAN_NAME
```