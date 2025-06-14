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

### Ubuntu(老)
```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
apt-get update --allow-unauthenticated
```

### Ubuntu(新)
```bash
cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources
sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources
apt-get update --allow-unauthenticated
```

### Ubuntu 24.04 源文件设置

/etc/apt/sources.list.d/ubuntu.sources
```
Types: deb
URIs: http://cn.archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
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

### CentOS huawei cloud
```shell
wget -O /etc/yum.repos.d/CentOS-hwcloud.repo https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo
wget -O /etc/yum.repos.d/CentOS-hwcloud.repo https://repo.huaweicloud.com/repository/conf/CentOS-8-reg.repo
```

### CentOS tencent cloud
```shell
wget -O /etc/yum.repos.d/CentOS-Tencent.repo https://mirrors.cloud.tencent.com/repo/centos7_base.repo
wget -O /etc/yum.repos.d/CentOS-Tencent.repo https://mirrors.cloud.tencent.com/repo/centos8_base.repo
```

### ArchLinux
```shell
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
```

### Armbian
```shell
sed -i.bak 's#http://apt.armbian.com#https://mirrors.tuna.tsinghua.edu.cn/armbian#g' /etc/apt/sources.list.d/armbian.list
apt update
```

### Kali
```shell
sed -i "s@http://http.kali.org/kali@https://mirrors.tuna.tsinghua.edu.cn/kali@g" /etc/apt/sources.list
```