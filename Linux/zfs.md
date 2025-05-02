
---

### **一、安装与基础配置**
#### **1. 安装 ZFS**
- **Debian/Ubuntu**：
  ```bash
  sudo apt install zfsutils-linux
  ```
- **手动编译**（内核不匹配时）：
- [安装依赖](https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html#installing-dependencies)
  ```bash
  git clone https://github.com/openzfs/zfs.git
  cd zfs
  ./autogen.sh
  ./configure --with-linux=/usr/src/linux-headers-$(uname -r) --with-linux-obj=/usr/src/linux-headers-$(uname -r)
  make -j$(nproc)
  sudo make install
  ```

#### **2. 创建存储池**
- **单磁盘池**（无冗余）：
  ```bash
  sudo zpool create mypool /dev/sda
  ```
- **镜像池**（推荐冗余）：
  ```bash
  sudo zpool create mypool mirror /dev/sda /dev/sdb
  ```
- **查看池状态**：
  ```bash
  zpool status
  ```

---

### **二、管理数据集**
#### **1. 创建数据集（类似子目录）**
```bash
sudo zfs create mypool/data
```
#### **2. 设置挂载点**
```bash
sudo zfs set mountpoint=/mnt/mydata mypool/data
```
#### **3. 查看属性**
```bash
zfs get all mypool/data
```

---

### **三、快照与恢复**
#### **1. 创建快照**
```bash
sudo zfs snapshot mypool/data@20231001
```
#### **2. 列出快照**
```bash
zfs list -t snapshot
```
#### **3. 恢复快照**
```bash
sudo zfs rollback mypool/data@20231001
```
#### **4. 删除快照**
```bash
sudo zfs destroy mypool/data@20231001
```

---

### **四、数据保护与传输**
#### **1. 克隆数据集**
```bash
sudo zfs clone mypool/data@20231001 mypool/cloned_data
```
#### **2. 发送/接收数据（跨池备份）**
```bash
# 发送快照到文件
sudo zfs send mypool/data@20231001 > backup.zfs

# 接收快照恢复
sudo zfs receive -F newpool/data < backup.zfs
```

---

### **五、优化与维护**
#### **1. 启用压缩（节省空间）**
```bash
sudo zfs set compression=lz4 mypool/data
```
#### **2. 禁用去重（避免内存耗尽）**
```bash
sudo zfs set dedup=off mypool
```
#### **3. 限制内存占用（小内存设备）**
```bash
echo "options zfs zfs_arc_max=536870912" | sudo tee /etc/modprobe.d/zfs.conf  # 限制为 512MB
sudo reboot
```
#### **4. 定期清理检查**
```bash
# 数据完整性检查
sudo zpool scrub mypool

# 查看池健康状态
zpool status -v
```

---

### **六、故障处理**
#### **1. 强制导入池**
```bash
sudo zpool import -f mypool
```
#### **2. 修复损坏设备**
```bash
sudo zpool replace mypool /dev/sda /dev/sdb
```
#### **3. 查看错误日志**
```bash
dmesg | grep zfs
```

---

### **七、常用命令速查**
| **功能**         | **命令**                          |
|------------------|-----------------------------------|
| 列出所有存储池   | `zpool list`                      |
| 查看数据集空间   | `zfs list -o name,used,avail`     |
| 重命名数据集     | `zfs rename oldname newname`      |
| 导出存储池       | `zpool export mypool`             |
| 升级存储池特性   | `zpool upgrade mypool`            |

---

以下是如何在 ZFS 中创建和管理加密数据集的补充内容：

---

### **八、加密数据集管理**
ZFS 支持原生加密（从 ZFS 0.8+ 开始），加密单位为数据集（Dataset）。以下是常用操作：

#### **1. 创建加密数据集**
```bash
# 创建时直接启用加密（需设置密码）
sudo zfs create -o encryption=aes-256-gcm -o keyformat=passphrase mypool/secret_data

# 输入加密密码（至少 8 字符）
```

#### **2. 使用密钥文件（免交互密码）**
```bash
# 生成随机密钥文件（推荐）
sudo dd if=/dev/urandom of=/etc/zfs/secret.key bs=32 count=1
sudo chmod 600 /etc/zfs/secret.key

# 创建加密数据集并绑定密钥文件
sudo zfs create -o encryption=aes-256-gcm -o keyformat=raw -o keylocation=file:///etc/zfs/secret.key mypool/encrypted_data
```

#### **3. 挂载/卸载加密数据集**
```bash
# 手动加载密钥并挂载（需密码或密钥）
sudo zfs load-key mypool/secret_data
sudo zfs mount mypool/secret_data

# 卸载并卸载密钥
sudo zfs unmount mypool/secret_data
sudo zfs unload-key mypool/secret_data
```

#### **4. 自动挂载加密数据集**
```bash
# 启用自动挂载（需提前加载密钥）
sudo zfs set keystatus=on mypool/secret_data
sudo zfs set mountpoint=/mnt/secret mypool/secret_data

# 开机时自动加载密钥（通过 systemd）
sudo systemctl enable zfs-load-key@mypool-secret_data.service
```

#### **5. 管理密钥和密码**
```bash
# 修改加密密码
sudo zfs change-key -l mypool/secret_data

# 添加备用密钥文件
sudo zfs create -o encryption=on -o keylocation=file:///path/new_key mypool/data

# 查看加密状态
zfs get encryption,keylocation,keystatus mypool/secret_data
```

---

### **注意事项**
1. **密钥备份**：  
   加密数据集完全依赖密钥，**务必备份密钥文件**到安全位置（如离线 U 盘）。丢失密钥将导致数据永久无法访问！

2. **性能影响**：  
   AES-256-GCM 加密对 CPU 有轻微负担（ARM 设备可能更明显），但对内存影响较小。

3. **跨系统挂载**：  
   迁移加密数据集时，需同时传输密钥文件，并在目标系统执行 `zfs load-key`。

---

### **加密常用命令速查**
| **功能**                | **命令**                                      |
|-------------------------|-----------------------------------------------|
| 强制卸载所有加密数据集  | `sudo zfs unmount -a && sudo zfs unload-key -a` |
| 临时挂载为明文          | `sudo zfs mount -o readonly=on -o keylocation=prompt mypool/data` |
| 加密现有数据集          | **不支持**，需创建新数据集并迁移数据。          |

---

通过加密功能，可以在共享存储或敏感数据场景中保护隐私。建议优先使用密钥文件+自动加载方案，避免频繁输入密码。


---

zfs-mount.sh
```shell
#!/bin/sh
zpool import -f -a
zfs load-key -a
zfs mount -a
```
系统启动时调用，比如[使用rc.local](rc.local开机执行命令.md)