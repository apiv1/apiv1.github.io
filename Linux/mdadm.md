# mdadm 命令

创建阵列

```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
sudo mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
sudo mdadm --create /dev/md0 --level=linear --raid-devices=2 /dev/sdb1 /dev/sdc1
```

查看状态

```bash
cat /proc/mdstat
sudo mdadm --detail /dev/md0
sudo mdadm --detail --scan
sudo mdadm --examine /dev/sdb1
```

管理维护

```bash
sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
sudo update-initramfs -u
sudo mdadm /dev/md0 --add /dev/sde1
sudo mdadm /dev/md0 --fail /dev/sdb1
sudo mdadm /dev/md0 --remove /dev/sdb1
sudo mdadm --stop /dev/md0
sudo mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1
sudo mdadm --assemble --scan
sudo mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1
```

删除清理

```bash
sudo umount /dev/md0
sudo mdadm --stop /dev/md0
sudo mdadm --zero-superblock /dev/sdb1
```

防止自动加载

```bash
sudo systemctl disable --now mdmonitor.service
sudo sed -i '/^ARRAY/d' /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

组合使用示例

```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo pvcreate /dev/md0
sudo vgcreate vg_raid /dev/md0
sudo lvcreate -L 500G -n lv_storage vg_raid
sudo mkfs.xfs /dev/vg_raid/lv_storage
sudo mount /dev/vg_raid/lv_storage /mnt/storage
```

安全卸载顺序

```bash
sudo umount /mnt/storage
sudo lvchange -an /dev/vg0/lv_data
sudo vgchange -an vg0
sudo mdadm --stop /dev/md0
```

安全提示：

安全操作：umount, mdadm --stop, vgchange -an, lvchange -an

破坏性操作（数据丢失）：mdadm --zero-superblock, lvremove, vgremove, pvremove
