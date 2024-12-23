[官方: 适用于 Windows 的 OpenSSH 入门](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui&pivots=windows-server-2025)
- - -
* 可选功能->添加OpenSSH Server
* 服务->OpenSSH Server自启动
* 高级安全防火墙->入站规则->OpenSSH->高级: 添加专有,公用.

配置OpenSSH默认Shell
```powershell
reg add HKEY_LOCAL_MACHINE\SOFTWARE\OpenSSH /v DefaultShell /t REG_SZ /D "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe" /f
```