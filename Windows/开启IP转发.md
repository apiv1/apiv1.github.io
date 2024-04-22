### 开启IP转发功能

需完成以下设置

* 注册表

管理员Shell内运行
```powershell
reg add HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v IPEnableRouter /D 1 /f
```

* 开启路由转发服务
```
services.msc -> Routing and Remote Access, 启用，启动
```