### armbian下载安装源码

例子设备是网心云, 里面源码已经被删除了, 所以要下载安装源码

```shell
ls -lah /lib/modules/$(uname -r)

total 2.5M
drwxr-xr-x  3 root root 4.0K Apr 25 15:44 .
drwxr-xr-x  3 root root 4.0K Mar 21 22:25 ..
lrwxrwxrwx  1 root root   42 Mar 17 23:29 build -> /builder/kernel/linux-rockchip-rk-6.1-rkr5
drwxr-xr-x 11 root root 4.0K Mar 17 23:29 kernel
-rw-r--r--  1 root root 635K Apr 25 15:44 modules.alias
-rw-r--r--  1 root root 650K Apr 25 15:44 modules.alias.bin
-rw-r--r--  1 root root  32K Mar 17 23:29 modules.builtin
-rw-r--r--  1 root root  17K Apr 25 15:44 modules.builtin.alias.bin
-rw-r--r--  1 root root  33K Apr 25 15:44 modules.builtin.bin
-rw-r--r--  1 root root 184K Mar 17 23:29 modules.builtin.modinfo
-rw-r--r--  1 root root 152K Apr 25 15:44 modules.dep
-rw-r--r--  1 root root 248K Apr 25 15:44 modules.dep.bin
-rw-r--r--  1 root root  243 Apr 25 15:44 modules.devname
-rw-r--r--  1 root root  89K Mar 17 23:29 modules.order
-rw-r--r--  1 root root  673 Apr 25 15:44 modules.softdep
-rw-r--r--  1 root root 197K Apr 25 15:44 modules.symbols
-rw-r--r--  1 root root 246K Apr 25 15:44 modules.symbols.bin
lrwxrwxrwx  1 root root   42 Mar 17 23:29 source -> /builder/kernel/linux-rockchip-rk-6.1-rkr5
```

源码放在 ```/builder/kernel/linux-rockchip-rk-6.1-rkr5``` 目录就行

```shell
mkdir -p /builder/kernel
cd /builder/kernel

wget https://github.com/armbian/linux-rockchip/archive/refs/heads/rk-6.1-rkr5.zip
unzip rk-6.1-rkr5.zip

# 解压出来 linux-rockchip-rk-6.1-rkr5
cd linux-rockchip-rk-6.1-rkr5

# 对源码目录执行预处理, 为后面编译操作做准备.
make oldconfig && make prepare && make modules_prepare
```