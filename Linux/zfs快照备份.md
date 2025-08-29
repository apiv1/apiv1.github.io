### syncoid 备份
```shell
# 安装syncoid
sudo apt install sanoid

# 文档：https://manpages.debian.org/testing/sanoid/syncoid.8.en.html#sshkey

# 备份到本地, 数据集底层数据拷贝, 若远端数据集加密过, 本地需要密钥才能读取.
syncoid -r --sshport=22 --sshkey=~/.ssh/id_rsa --sendoptions="w" backup-user@backup-server:backup_pool/encrypted_data tank/encrypted_data

# 在本地通过密钥解密查看
sudo zfs load-key -t -L "file:///tmp/temp_key" tank/temp_encrypted
```

### 待备份工具安装压缩和缓冲工具
没装有可能会警告
```shell
sudo apt-get install lzop mbuffer
```

### 为用户分配数据集备份需要的权限
```shell
sudo zfs allow -u $USER snapshot,send,create,destroy,hold tank/dataset # 授予用户源数据集操作权限
sudo zfs allow -u $USER create,receive,mount tank/backup # 授予用户目标数据集接收权限

# 查看
sudo zfs allow $USER

# 撤消
sudo zfs unallow $USER pool/dataset # 撤销指定用户的所有权限
sudo zfs unallow -u $USER create,destroy pool/dataset # 撤销用户的特定权限
sudo zfs unallow -e snapshot pool/dataset # 撤销所有用户的特定权限
sudo zfs unallow -s @setname pool/dataset # 撤销整个权限集

sudo zfs unallow -l $USER pool/dataset # 仅撤销本地文件系统权限（不继承）
sudo zfs unallow -r $USER pool/dataset # 递归撤销所有后代文件系统权限
```

### 快照操作
```shell
sudo zfs snapshot tank/backup@test # 创建快照
sudo zfs list -t snapshot # 列出所有快照
sudo zfs destroy tank/dataset@snapshotname # 删除指定快照
```