### Debian
```bash
sed -i "s/deb.debian.org/ftp.cn.debian.org/g" /etc/apt/sources.list
```

### Ubuntu
```bash
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
```

### Alpine
```bash
sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories
```