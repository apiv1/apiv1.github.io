查看 yarn.lock 有哪些安装源
```shell
grep -o 'https:\/\/[^\/]*' ./yarn.lock | sort | uniq
```

替换 yarn.lock 安装源
```shell
# source.com 替换成自己指定的安装源
sed -i 's/https:\/\/[^\/]*\//https:\/\/source.com\//g' ./yarn.lock
```