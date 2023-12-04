### 安装
```shell
sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
```

### 查看IP
```bash
sudo virsh list --all
sudo virsh domifaddr <vm name>  --source arp
```

### 共享文件夹
1. KVM里添加挂载
```
 <devices>
   ...Œ
   <filesystem type='mount' accessmode='passthrough'>
     <source dir='$SOURCE_DIR'/>
     <target dir='$SHARED_FOLDER'/>
   </filesystem>
   ...
 </devices>
```

2. 启动VM, 进VM后执行挂载
```bash
mount -t 9p -o trans=virtio $SHARED_FOLDER /mnt
```
/etc/fstab
```
$SHARED_FOLDER               /mnt                9p      trans=virtio,version=9p2000.L,defaults,uid=1000,gid=1000,umask=022,dir_mode=0777,file_mode=0777   0       0
```

### 挂载硬盘
```
<disk type="block" device="disk">
  <driver name="qemu" type="raw" cache="none"/>
  <source dev="/dev/hda"/>
  <target dev="sda" bus="sata"/>
  <address type="drive" controller="0" bus="0" target="0" unit="0"/>
</disk>

```

### 重置网络
```bash
# 卸载
virsh net-destroy default
virsh net-undefine default
```

```bash
# 配置
mkdir -p /var/lib/libvirt/network
cat <<EOF > /var/lib/libvirt/network/default.xml
<network>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0' />
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254' />
    </dhcp>
  </ip>
</network>
EOF

virsh net-define /var/lib/libvirt/network/default.xml
virsh net-start default
virsh net-autostart default
```