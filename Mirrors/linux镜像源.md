### Debian 8 (不再支持)
```shell
echo deb http://snapshot.debian.org/archive/debian-archive/20190328T105444Z/debian/ jessie main > /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated
```

### Debian (老)
```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list
apt-get update --allow-unauthenticated
```

### Debian (新)
```bash
cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak
sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list.d/debian.sources
apt-get update --allow-unauthenticated
```

### Ubuntu
```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
apt-get update --allow-unauthenticated
```

### Alpine
```bash
sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories
```
### CentOS-Stream9
```bash
cp /etc/yum.repos.d/centos.repo /etc/yum.repos.d/centos.repo.bak
sed -i "/.*#.*GENERATED.*/d" /etc/yum.repos.d/centos.repo
sed -i "/.*\[baseos\].*/a\baseurl=https://mirror.tuna.tsinghua.edu.cn/centos-stream/9-stream/BaseOS/ # GENERATED" /etc/yum.repos.d/centos.repo
sed -i "/.*\[appstream\].*/a\baseurl=https://mirror.tuna.tsinghua.edu.cn/centos-stream/9-stream/AppStream/ # GENERATED" /etc/yum.repos.d/centos.repo
sed -i "/.*\[crb\].*/a\baseurl=https://mirror.tuna.tsinghua.edu.cn/centos-stream/9-stream/CRB/ # GENERATED" /etc/yum.repos.d/centos.repo
yum update
```

### ArchLinux
```shell
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
```