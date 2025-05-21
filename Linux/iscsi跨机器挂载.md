### iscsi跨机器挂载

#### ~~服务端安装~~

安装
```shell
sudo apt install -y tgt
```

配置

/etc/tgt/conf.d/zfs.conf
```conf
<target iqn.2025-05.example:storage.sda>
    # 指定路径
    backing-store /dev/sda
    # 控制访问权限（可选）
    initiator-address ALL # 允许指定网段访问
    # CHAP 认证（可选）
    incominguser user pass
</target>
```

运行
```shell
sudo systemctl start tgt
```

#### Docker安装服务端

[compose.yml](../Docker/tgtd/compose.yml)
[.env](../Docker/tgtd/env.example) 这是例子

配置（帐号密码卷等）放.env里

#### 客户端

安装
```shell
sudo apt install open-iscsi
sudo systemctl enable --now iscsid
```

mount.sh
```shell
IP=<IP>
NAME=iqn.2025-05.example:storage.sda
USERNAME=user
PASSWORD=pass

# 发现
sudo iscsiadm -m discovery -t st -p $IP

# 使用 CHAP 认证（如果配置了）
sudo iscsiadm -m node -T $NAME -p $IP --op update -n node.session.auth.authmethod -v CHAP
sudo iscsiadm -m node -T $NAME -p $IP --op update -n node.session.auth.username -v $USERNAME
sudo iscsiadm -m node -T $NAME -p $IP --op update -n node.session.auth.password -v $PASSWORD

# 连接
sudo iscsiadm -m node -T $NAME -p $IP --login
```

umount.sh
```shell
NAME=iqn.2025-05.example:storage.sda

sudo iscsiadm -m session
sudo iscsiadm -m node -T $NAME -u
sudo iscsiadm -m node -T $NAME -o delete
```

挂载一次后, 随服务运行自动挂载, 直至手动卸载。
