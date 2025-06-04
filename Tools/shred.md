### 递归删除文件夹
```shell
DELETE_DIRECTORY='文件夹'
find "$DELETE_DIRECTORY" -type f -exec shred -uvz {} \;
rm -rf "$DELETE_DIRECTORY"
```