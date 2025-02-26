# launchd
启动服务，用于开机启动，登录启动。

### 目录
`/Library/LaunchAgents/`: 用户登录时执行
`/Library/LaunchDaemons/`: 开机时执行

### 示例
/Library/LaunchDaemons/daemon.plist
```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>daemon</string>
    <key>ProgramArguments</key>
    <array>
      <string>/daemon/run.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/daemon.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/daemon.stderr.log</string>
    <key>WorkingDirectory</key>
    <string>/tmp</string>
</dict>
</plist>
```

### 使用
```shell
# 启停
sudo launchctl load /Library/LaunchDaemons/daemon.plist
sudo launchctl unload /Library/LaunchDaemons/daemon.plist
```