### Linux挂载SMB

安装
```shell
sudo apt-get install cifs-utils
```

挂载
```shell
sudo mount -t cifs //server/share /mnt/smb -o username=user,password=pass
```

```/etc/fstab```自动挂载
```
//server/share /mnt/smb cifs username=user,password=pass 0 0

//server/share /mnt/smb cifs username=user,password=pass,gid=id,uid=id 0 0 # 给权限
```