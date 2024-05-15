### 使用route设置路由

* 需要使用管理员shell

例子
```powershell
# 设置路由 将发给1.1.1.1的数据包使用192.168.1.100作为网关发送
route add 1.1.1.1 192.168.1.100

# -p 参数为设置永久路由, 重启后还生效
route add -p 2.2.2.2 192.168.1.100

# 删除路由
route delete 1.1.1.1
route delete 2.2.2.2

# 查看路由
route print
```

Windows route命令无法设置 mtu值, 设置mtu值参考[这里](./netsh设置.md)
