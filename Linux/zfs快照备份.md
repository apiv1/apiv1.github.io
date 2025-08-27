### syncoid 备份
```shell
# 安装syncoid
sudo apt install sanoid

# 文档：https://manpages.debian.org/testing/sanoid/syncoid.8.en.html#sshkey

# 备份到本地
syncoid -r --sshport=22 --sshkey=~/.ssh/id_rsa --sendoptions="w" backup-user@backup-server:backup_pool tank/encrypted_data

# 在本地通过密钥解密查看
sudo zfs load-key -t -L "file:///tmp/temp_key" tank/temp_encrypted
```