# 构建镜像

immortalwrt镜像比较碎片化, 需要自己从img里构建镜像

根据自己设备型号选择固件, 下载***factor-ext4***版本的镜像. [下载地址](https://firmware-selector.immortalwrt.org/)

下载的镜像文件名称是 ```xxx-ext4-factory.img.gz``` 这个镜像本来是作为固件刷入的, 现在要做成docker镜像.

### 制作docker镜像步骤

#### 下载和解压镜像
```shell
# 解压
gunzip -k xxx-ext4-factory.img.gz # 生成一个体积巨大的镜像文件, 接下来docker构建的时候不要把它放进build context目录, 会把它打包进去的.
mv xxx-ext4-factory.img rootfs.img

ls -lah rootfs.img # 会发现体积比img.gz大很多
```

#### 用fdisk命令查看镜像文件的根目录分区偏移量
```shell
fdisk -l rootfs.img
```
会看到类似输出
```shell
...
Device      Boot  Start    End Sectors  Size Id Type
rootfs.img1 *      8192 139263  131072   64M  c W95 FAT32 (LBA)
rootfs.img2      147456 761855  614400  300M 83 Linux
```
这里这个 根分区起始偏移就是 ```147456```. 在自己的案例下需要使用具体的偏移值.

#### 挂载根分区
```shell
offset=$((147456 * 512)) # 计算偏移

mkdir -p build/rootfs # 创建构建文件夹和挂载文件夹
sudo mount -o loop,offset=$offset rootfs.img build/rootfs # 根据分区偏移进行挂载

ls build/rootfs # 查看挂载结果
```
如果挂载正常, 输出根目录文件夹列表
```shell
bin  dev  etc  lib  lib64  lost+found  mnt  overlay  proc  rom  root  sbin  sys  tmp  usr  var  www
```

#### 开始构建镜像
```shell
cd build

printf "FROM scratch\nCOPY rootfs/ /" | docker build -f - . -t immortalwrt:base -t immortalwrt:current
```

#### 清理工作
```shell
sudo umount rootfs
cd ..
rm -rf build rootfs.img
```

### 总结
镜像已经生成,命名为 ```immortalwrt:base```, ```immortalwrt:current```

在软路由环境中做的更新, 使用```docker commit```命令进行持久化

若需恢复软路由出厂设置, 使用```docker tag immortalwrt:base immortalwrt:current```