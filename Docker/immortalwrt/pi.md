### 树莓派设置延时启动hostapd

经测试, hostapd需要延迟启动, 在桌面加载好后再启动热点. 否则brlan以及相关一系列设置都会出问题.
```shell
sudo systemctl disable hostapd # 取消服务自启动
vim ~/.config/autostart/hostapd.desktop
chmod +x ~/.config/autostart/hostapd.desktop
```

~/.config/autostart/hostapd.desktop
```desktop
[Desktop Entry]
Type=Application
Name=hostapd
Exec=sudo systemctl start hostapd
```