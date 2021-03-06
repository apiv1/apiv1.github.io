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