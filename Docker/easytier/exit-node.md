### 出口节点
#### 终端设置

访问端
```shell
easytier-core --exit-nodes <出口节点虚拟IP> [其他参数]
```

出口节点设备
```shell
easytier-core -i <出口节点虚拟IP> --enable-exit-node [其他参数]
```

配置文件设置
```toml
exit_nodes = ["出口节点虚拟IP"]
[flags]
enable_exit_node = true
```

#### GUI客户端设置

访问端

```高级设置->出口节点列表```

出口节点设备

```高级设置->启用出口节点```

- - -
* 终端和gui设置是相同的
* 如果没有设置出口节点列表和启用出口节点则后面的路由设置不会生效。

### 路由设置

运行easytier看到出口节点设备后还要设置路由才能使用，不使用时可以手动删除路由。（关闭easytier或重启机器也会清除）

#### 这里路由配置的IP是Gateway IP，要使用自己的easytier节点ip，不是exit node的ip。 先要查看自己的easytier节点的ip。
- - -

Windows，需要管理员终端
```powershell
# 可选：本地网关（路由器），用于本地局域网不走出口节点
$LOCAL_GATEWAY="192.168.1.1"

# 可选：添加本地局域网路由
route add 10.0.0.0 mask 255.0.0.0 "$LOCAL_GATEWAY"
route add 172.16.0.0 mask 255.240.0.0 "$LOCAL_GATEWAY"
route add 192.168.0.0 mask 255.255.0.0 "$LOCAL_GATEWAY"
# 可选：删除本地局域网路由
route delete 10.0.0.0 mask 255.0.0.0 "$LOCAL_GATEWAY"
route delete 172.16.0.0 mask 255.240.0.0 "$LOCAL_GATEWAY"
route delete 192.168.0.0 mask 255.255.0.0 "$LOCAL_GATEWAY"

# 指定Gateway，是自己的easytier节点ip
$IP="10.126.126.1"

# 添加默认路由到出口节点
route add 0.0.0.0 mask 0.0.0.0 "$IP"
# 删除默认路由到出口节点
route delete 0.0.0.0 mask 0.0.0.0 "$IP"

# 查看路由
route print
```

Linux
```shell
# 可选：本地网关（路由器），用于本地局域网不走出口节点
LOCAL_GATEWAY="192.168.1.1"

# 可选：添加本地局域网路由
sudo ip route add 10.0.0.0/8 via $LOCAL_GATEWAY
sudo ip route add 172.16.0.0/12 via $LOCAL_GATEWAY
sudo ip route add 192.168.0.0/16 via $LOCAL_GATEWAY

# 可选：删除本地局域网路由
sudo ip route del 10.0.0.0/8 via $LOCAL_GATEWAY
sudo ip route del 172.16.0.0/12 via $LOCAL_GATEWAY
sudo ip route del 192.168.0.0/16 via $LOCAL_GATEWAY

# 指定Gateway，是自己的easytier节点ip
IP="10.126.126.1"

# 添加默认路由到出口节点
sudo ip route add default via $IP
# 删除默认路由到出口节点
sudo ip route del default via $IP

#查看路由
ip route show
```

Mac
```shell
# 可选：本地网关（路由器），用于本地局域网不走出口节点
LOCAL_GATEWAY="192.168.1.1"

# 可选：添加本地局域网路由
sudo route -n add -net 10.0.0.0/8 $LOCAL_GATEWAY
sudo route -n add -net 172.16.0.0/12 $LOCAL_GATEWAY
sudo route -n add -net 192.168.0.0/16 $LOCAL_GATEWAY

# 可选：删除本地局域网路由
sudo route -n delete -net 10.0.0.0/8 $LOCAL_GATEWAY
sudo route -n delete -net 172.16.0.0/12 $LOCAL_GATEWAY
sudo route -n delete -net 192.168.0.0/16 $LOCAL_GATEWAY

# 指定Gateway，是自己的easytier节点ip
IP="10.126.126.1"

# 添加默认路由到出口节点
sudo route add default $IP
# 删除默认路由到出口节点
sudo route delete default $IP

# 查看路由
netstat -rn
```