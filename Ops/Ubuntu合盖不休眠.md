```/etc/systemd/logind.conf```

HandlePowerKey: 按下电源键后的行为，默认power off
HandleSleepKey: 按下挂起键后的行为，默认suspend
HandleHibernateKey: 按下休眠键后的行为，默认hibernate
HandleLidSwitch: 合上笔记本盖后的行为，默认suspend

ignore(无操作),
poweroff(关闭系统并切断电源),
reboot(重新启动),
halt(关闭系统但不切断电源),
kexec(调用内核"kexec"函数),
suspend(休眠到内存),
hibernate(休眠到硬盘),
hybrid-sleep(同时休眠到内存与硬盘),
suspend-then-hibernate(先休眠到内存超时后再休眠到硬盘),
lock(锁屏)

```shell
service systemd-logind restart
systemctl restart systemd-logind
```

休眠服务的启停
```shell
# 停止服务
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# 启动服务
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```