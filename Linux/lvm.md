# LVM 命令

物理卷(PV)操作

```bash
sudo pvcreate /dev/sdc1
sudo pvdisplay
sudo pvs
sudo pvscan
sudo pvmove /dev/sdc1
sudo vgreduce vg0 /dev/sdc1
sudo pvremove /dev/sdc1
```

卷组(VG)操作

```bash
sudo vgcreate vg0 /dev/sdb1 /dev/sdc1
sudo vgdisplay
sudo vgs
sudo vgextend vg0 /dev/sdd1
sudo vgreduce vg0 /dev/sdc1
sudo vgchange -ay vg0
sudo vgchange -an vg0
sudo vgrename old_vg new_vg
sudo vgremove vg0
```

逻辑卷(LV)操作

```bash
sudo lvcreate -L 100G -n lv_data vg0
sudo lvcreate -l 100%FREE -n lv_data vg0
sudo lvcreate -l 50%VG -n lv_data vg0
sudo lvdisplay
sudo lvs
sudo lvextend -L +50G /dev/vg0/lv_data
sudo lvextend -L 500G /dev/vg0/lv_data
sudo lvextend -l +100%FREE /dev/vg0/lv_data
sudo lvreduce -L 300G /dev/vg0/lv_data
sudo lvremove /dev/vg0/lv_data
```

文件系统操作

```bash
sudo mkfs.ext4 /dev/vg0/lv_data
sudo mkfs.xfs /dev/vg0/lv_data
sudo resize2fs /dev/vg0/lv_data
sudo xfs_growfs /mnt/data
sudo umount /mnt/data
sudo e2fsck -f /dev/vg0/lv_data
sudo resize2fs /dev/vg0/lv_data 300G
```

挂载操作

```bash
sudo mount /dev/vg0/lv_data /mnt/data
sudo blkid /dev/vg0/lv_data
```

快照功能

```bash
sudo lvcreate -L 10G -s -n lv_snap /dev/vg0/lv_data
sudo lvdisplay /dev/vg0/lv_snap
sudo umount /mnt/data
sudo lvconvert --merge /dev/vg0/lv_snap
sudo lvremove /dev/vg0/lv_snap
```
