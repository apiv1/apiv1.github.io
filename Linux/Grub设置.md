### Grub设置
/etc/default/grub
```shell
# Grub下次的启动项设为默认
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true

GRUB_TIMEOUT_STYLE=menu  # 显示菜单
GRUB_TIMEOUT=10   # 超时时间10秒
GRUB_DISABLE_OS_PROBER=false   # 允许os探测
```

更新
```shell
update-grub
```

### 使用Ubuntu LiveCD修复引导项
LiveCD内执行:
```shell
# 替换成自己的分区路径
export HARDDISK=/dev/sdX # 硬盘设备
export ROOT_PARTITION=/dev/sdX1 # 系统分区
export EFI_PARTITION=/dev/sdX2 # EFI 分区

# 挂载原系统目录，EFI目录，运行时状态和设备文件夹到/mnt
sudo mount $ROOT_PARTITION /mnt
sudo mount $EFI_PARTITION /mnt/boot/efi
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done

# 拷贝grub配置到原系统, 为了grub-install efi
sudo cp -R /usr/lib/grub/x86_64-efi /mnt/usr/lib/grub/x86_64-efi

# 配置好/mnt后， 切换根目录到/mnt
sudo chroot /mnt

# 在chroot环境内执行grub安装操作
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB $HARDDISK
update-grub
```