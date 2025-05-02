### rc.local 开机执行命令

1. 添加文件

/lib/systemd/system/rc-local.service.d/rc-local.service
```
[Unit]
Description=/etc/rc.local Compatibility
Documentation=man:systemd-rc-local-generator(8)
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=infinity
RemainAfterExit=yes
GuessMainPID=no

[Install]
WantedBy=multi-user.target
Alias=rc-local.service
```
2. 配置
```shell
chmod +x /lib/systemd/system/rc-local.service.d/rc-local.service
chmod +x /etc/rc.local
ln -s /lib/systemd/system/rc-local.service.d/rc-local.service /etc/systemd/system/
```

3. rc.local

/etc/rc.local
```sh
#!/bin/sh

exit 0
```