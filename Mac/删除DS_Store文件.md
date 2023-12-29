删除DS_Store文件
```shell
find . -name .DS_Store -exec rm -rvf {} \;
```

处理无用的元数据文件
```shell
# 列出文件, 查看
find . -name '._*' -exec ls -lah {} \; | less

# 直接删除
find . -name '._*' -exec rm -rvf {} \;
```

禁止生成网络驱动器里的.DS_Store
```shell
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```
