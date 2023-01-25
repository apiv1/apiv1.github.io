### User
```shell
useradd -m kodi
usermod -a -G video kodi
usermod -a -G audio kodi
```

### Deps
apt-get install xinit dbus-x11 kodi
###

/etc/X11/Xwrapper.config
```
allowed_users=anybody
needs_root_rights=yes
```

### Service
/etc/systemd/system/kodi.service
```
[Unit]
Description = kodi-standalone using xinit
After = remote-fs.target systemd-user-sessions.service mysql.service

[Service]
User = kodi
Group = kodi
Type = simple
ExecStart = /usr/bin/xinit /usr/bin/dbus-launch /usr/bin/kodi-standalone -- :0 -nolisten tcp
Restart = always
RestartSec = 5

[Install]
WantedBy = multi-user.target
```