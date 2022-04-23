1.列出分区, 找到待挂载分区
```powershell
diskpart
list disk
select disk <disk no>
list part

# 或者用wmic命令
wmic diskdrive list brief

# 或者磁盘管理
```
2.管理员权限下使用wsl挂载
```powershell
wsl --mount \\.\PHYSICALDRIVE0 --partition 0 # 举例: 挂载第0个硬盘第0个分区
```
若挂载失败显示占用, 则打开磁盘管理, 脱机磁盘后再联机.