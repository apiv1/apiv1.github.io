### Deps
```shell
sudo apt install x11vnc
```

### Service
 /lib/systemd/system/x11vnc.service
```
[Unit]
Description=x11vnc service
#在启动x11vnc之前，启动其他依赖的系统服务
After=display-manager.service network.target syslog.target
[Service]
Type=simple
#为x11vnc创建一个子进程
# -forever表示在后台长期运行
# -auth 表示验证的用户名。
# -passwd 表示验证的密码
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth itdog -passwd password@000
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure
[Install]
#在进程进入multi-user.target之前启动服务。
WantedBy=multi-user.target
```