#### 本地安全策略, 允许Administrator
设置方法: ```secpol.msc```->安全设置->本地策略->安全选项->账户:管理员账户状态=启用

#### 获得Administrator powershell
```powershell
runas /user:Administrator powershell
```

判断是不是Administrator
```powershell
(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)