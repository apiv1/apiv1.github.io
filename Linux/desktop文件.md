### app.desktop 例子
```desktop
[Desktop Entry]
Name=MyProgram
Comment=This is my program that runs on startup
Exec=/path/to/your/app # 在此处输入要执行的命令或程序的路径
Icon=/path/to/your/icon.png  # 可选，指定一个图标路径
Terminal=false  # 如果不需要在终端中运行程序，则设置为false
MultipleArgs=false
Type=Application
Categories=Application;
StartupNotify=true  # 可选，设置是否在程序启动时发送通知
```

### app.desktop 简化版例子
```desktop
[Desktop Entry]
Type=Application
Name=testbootNo
Display=true
Exec=/home/pi/openchrom.sh
```

### 进入桌面后自动启动程序

创建入口程序```app.desktop```
```shell
mkdir -p ~/.config/autostart
cd ~/.config/autostart
vi app.desktop
chmod +x app.desktop
```

### desktop文件目录
```shell
~/.local/share/applications
```