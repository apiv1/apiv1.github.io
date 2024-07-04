### Ubuntu等待网络
启动报错如下, 会卡很久才能进去
```
A start job is running for hait for Network to be Configured
```

##### 解决方式

编辑配置文件
```shell
sudo vim /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service
```

添加超时值
```service
[Service]
...
TimeoutStartSec=2sec
```