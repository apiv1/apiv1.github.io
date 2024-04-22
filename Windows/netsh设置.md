### netsh 设置

* 需要使用管理员shell

```powershell
# 列出所有网络接口
netsh interface ipv4 show interfaces

# 给网络接口设置mtu值
# 这里 "以太网" 是网络接口名字
# 根据 列出的网络接口 设置对应的接口名字
# store=persistent 意思是持久化设置, 重启后还生效
netsh interface ipv4 set subinterface "以太网" mtu=1400 store=persistent
```