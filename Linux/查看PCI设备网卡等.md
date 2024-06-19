### 查看pci设备
```shell
lspci -tv # 列出所有PCI设备
lspci | grep -i ethernet # 有线网卡型号
lspci | grep Network # 无线网卡型号

# 网络设备信息
lspci | grep -i net

# 查询网卡驱动型号
lshw -C network

# 显卡
lspci | grep VGA
```

### 在grub配置iommu支持
/etc/default/grub
```shell
GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt" # 追加
```

刷新grub.cfg
```shell
grub-mkconfig -o /boot/grub/grub.cfg
# 重启, bios里要开vx/d和pcie直通
```

检查 IOMMU 是否已启用
```shell
dmesg | grep DMAR
cat /proc/cmdline | grep intel_iommu
```