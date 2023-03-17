```shell
# 删除当前目录下五天以前创建的文件/文件夹
find -maxdepth 1 -ctime +5 | xargs rm -rf
find . -mtime +5 -exec rm -rf {} \
```