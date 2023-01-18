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
   ...
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