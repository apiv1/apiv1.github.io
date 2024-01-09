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
# -- 查找所有规则
iptables -L INPUT --line-numbers

# -- 删除一条规则
iptables -D INPUT 11 （注意，这个11是行号，是iptables -L INPUT --line-numbers 所打印出来的行号）
```