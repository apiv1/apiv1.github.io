

1. 改组策略
```
[计算机配置] --> [管理模板] --> [Windows组件] --> [远程桌面服务] --> [远程桌面会话主机] --> [连接]
[限制连接数量] 启用, 改最大
[允许用户通过使用远程桌面服务进行远程连接] 启用
[将远程桌面服务用户限制到单独的远程桌面服务会话] 启用
```
2. ```C:\Program Files\RDP Wrapper```这个文件夹添加到[杀软排除目录](./自带杀软设置排除文件.md)里
3. [RDPWrap](https://github.com/SobieskiCodes/RDPWrap) 下载这个 安装


4. 创建用户, 并添加到远程组
打开管理员终端
```powershell
# 创建并添加组, 设置用户名密码, 并添加到远程组
$USER='';$PASS=''
net user $USER $PASS /add
net localgroup 'Remote Desktop Users' $USER /add

# 删除用户
net user $USER /del
```