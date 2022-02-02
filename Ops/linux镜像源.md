### Debian
```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i "s/deb.debian.org/ftp.cn.debian.org/g" /etc/apt/sources.list
apt-get update --allow-unauthenticated
```

### Ubuntu
```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
apt-get update --allow-unauthenticated
```

### Alpine
```bash
sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories
```