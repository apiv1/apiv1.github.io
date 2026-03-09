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
- - -

Windows，需要管理员终端
```powershell
# 设置出口节点IP
$IP="10.126.126.1"

# 添加
route add 0.0.0.0 mask 0.0.0.0 "$IP"
# 删除
route delete 0.0.0.0 mask 0.0.0.0 "$IP"

# 查看路由
route print
```

Linux
```shell
# 设置出口节点IP
IP="10.126.126.1"

# 添加
sudo ip route add default via $IP

# 删除
sudo ip route del default via $IP

#查看路由
ip route show
```

Mac
```shell
# 设置出口节点IP
IP="10.126.126.1"

# 添加
sudo route add default $IP

# 删除
sudo route delete default $IP

# 查看路由
netstat -rn
```