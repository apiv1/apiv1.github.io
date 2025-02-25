# SSHFS
通过ssh共享文件夹

### Mac
```shell
# 安装
brew install --cask macfuse
brew install gromgit/fuse/sshfs-mac

# 挂载
sshfs -p 22 user@host.name:/data/path ~/datacenter -ovolname=datacenter
```

### Linux
```shell
# 安装
sudo apt install -y sshfs

# 挂载
sshfs -p 22 user@host.name:/data/path ~/datacenter -ovolname=datacenter
```

### Windows
管理员shell
```powershell
# 安装
winget install SSHFS-Win.SSHFS-Win

# 挂载
net use Z: \\sshfs.r\user@host.name!22\data\path
```