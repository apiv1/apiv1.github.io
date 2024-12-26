作用: 开启后, 通过 ```ping 主机名.local``` 来查看主机ip

/etc/systemd/resolved.conf
添加
```conf
LLMNR=yes
MulticastDNS=yes
```

安装 Avahi
```shell
sudo apt install avahi-daemon avahi-utils
sudo systemctl enable --now avahi-daemon.service
```