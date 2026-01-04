开启

```bash
echo "1" > /proc/sys/net/ipv4/ip_forward
# or
sysctl -w net.ipv4.ip_forward=1

# 开机时自动设置
# /etc/sysctl.conf
net.ipv4.ip_forward = 1
```

```bash
# 打开iptables的NAT功能:
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

```bash
# 转发
iptables -t nat -A PREROUTING -p tcp --dport ${SRC_PORT} -j REDIRECT --to-port ${DST_PORT}
iptables -t nat -A PREROUTING -p tcp --dport ${SRC_PORT} -j REDIRECT --to-source ${DST_HOST} --to-port ${DST_PORT}

# 转发其他机器
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A PREROUTING -p tcp --dport ${SRC_PORT} -j DNAT --to-destination ${DST_HOST}:${DST_PORT}
iptables -t nat -A POSTROUTING -p tcp -d ${DST_HOST} --dport ${DST_PORT} -j SNAT --to-source ${SRC_HOST}
```


```bash
# 查看所有iptables规则
iptables -L -n -v

# 查看所有NAT表规则
iptables -t nat -L -n -v

# 查看所有filter表规则（默认表）
iptables -t filter -L -n -v

# -- 查找所有规则
iptables -L INPUT --line-numbers

# -- 删除一条规则
iptables -D INPUT 11 （注意，这个11是行号，是iptables -L INPUT --line-numbers 所打印出来的行号）
```

#### 主机A使用主机B的子网收发数据

```bash
IP=192.168.1.101 # 主机B IP
SUB_NET=192.168.2.0/24 # 目标子网网段

# 主机A, 配置路由: 发给子网的数据, 把B主机当做网关.
sudo ip route add $SUB_NET via $IP
# --------------------------------------------------------------

# 主机B 设置
# 配置IP伪装, 转发过来的数据包, 源地址将重写成子网地址
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -L POSTROUTING # 检查
```

#### 重定向数据

例子: 重定向http

```shell
sysctl -w net.ipv4.ip_forward=1 # 开启转发

iptables -t nat -N HTTP_REDIRECT
iptables -t nat -A PREROUTING -j HTTP_REDIRECT

IPTABLES_ARGS=''
test -n "$INTERFACE" && IPTABLES_ARGS="-i $INTERFACE"
test -n "$DST_HOST" && IPTABLES_ARGS="$IPTABLES_ARGS -d $DST_HOST"

iptables -t nat -A HTTP_REDIRECT -p tcp --dport 443 -j REDIRECT --to-ports 8443 $IPTABLES_ARGS
iptables -t nat -A HTTP_REDIRECT -p tcp --dport 80 -j REDIRECT --to-ports 8080 $IPTABLES_ARGS

### 使用DNAT, 定向到指定IP的特定端口
iptables -t nat -A HTTP_REDIRECT -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100:8080 $IPTABLES_ARGS
```

删除

```shell
iptables -t nat -D PREROUTING -j HTTP_REDIRECT
iptables -t nat -F HTTP_REDIRECT
iptables -t nat -X HTTP_REDIRECT
```