```shell
lspci -tv # 列出所有PCI设备
lspci | grep -i ethernet # 有线网卡型号
lspci | grep Network # 无线网卡型号

# 网络设备信息
lspci | grep -i net

# 查询网卡驱动型号
lshw -C network
```