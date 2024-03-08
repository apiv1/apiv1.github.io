```powershell
# 打开
notepad.exe "$([Environment]::GetFolderPath('System'))\drivers\etc\hosts"

# 管理员权限编辑
Start-Process notepad.exe "$([Environment]::GetFolderPath('System'))\drivers\etc\hosts" -verb RunAs
```