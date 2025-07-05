### syncoid 备份
```shell
# 安装syncoid
sudo apt install sanoid

# 备份到本地
syncoid -r --sendoptions="w" backup-user@backup-server:backup_pool  tank/encrypted_data

# 在本地通过密钥解密查看
sudo zfs load-key -t -L "file:///tmp/temp_key" tank/temp_encrypted
```