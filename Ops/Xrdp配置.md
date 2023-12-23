Linux配置xrdp: [https://docs.microsoft.com/zh-cn/azure/virtual-machines/linux/use-remote-desktop](https://docs.microsoft.com/zh-cn/azure/virtual-machines/linux/use-remote-desktop)

```bash
# 安装xfce4(可选)
sudo apt-get -y install xfce4
sudo apt install xfce4-session
echo xfce4-session >~/.xsession

# 安装
sudo apt-get -y install dbus-x11 # optional
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
```

```bash
# CentOS Stream9 安装
sudo dnf install -y epel-release
sudo dnf install -y xrdp
sudo systemctl enable xrdp --now
sudo systemctl disable firewalld --now # 可能要关闭防火墙
```

```bash
# 登录后不需要授权给管理器, 不一定需要执行这个
cat <<EOF > /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
polkit.addRule(function(action, subject) {
 if ((action.id == "org.freedesktop.color-manager.create-device" ||
 action.id == "org.freedesktop.color-manager.create-profile" ||
 action.id == "org.freedesktop.color-manager.delete-device" ||
 action.id == "org.freedesktop.color-manager.delete-profile" ||
 action.id == "org.freedesktop.color-manager.modify-device" ||
 action.id == "org.freedesktop.color-manager.modify-profile") &&
 subject.isInGroup("{users}")) {
 return polkit.Result.YES;
 }
});
EOF
```


### [KDE-Plasma 配置](https://askubuntu.com/questions/1237288/20-04-xrdp-kde-plasma-connect-issue)
```

This is how I configure XRDP for KDE-Plasma (works on my Ubuntu 20.04)

sudo apt install -y xrdp
sudo sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
sudo systemctl enable xrdp
sudo systemctl restart xrdp
Set session to plasma:

echo "/usr/bin/startplasma-x11" > ~/.xsession
variables for xsessionrc:

export D=/usr/share/plasma:/usr/local/share:/usr/share:/var/lib/snapd/desktop
export C=/etc/xdg/xdg-plasma:/etc/xdg
export C=${C}:/usr/share/kubuntu-default-settings/kf5-settings


cat <<EOF > ~/.xsessionrc
export XDG_SESSION_DESKTOP=KDE
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=${C}
EOF
If you have plasma installed, you can also login, and execute this on a console:

echo $XDG_SESSION_DESKTOP
echo $XDG_DATA_DIRS
echo $XDG_CONFIG_DIRS
to see if your values are the same.

Now to avoid the "authentication-required"-dialog:

cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-NetworkManager.pkla
[Netowrkmanager]
Identity=unix-group:sudo
Action=org.freedesktop.NetworkManager.network-control
ResultAny=yes
ResultInactive=yes
ResultActive=yes
EOF


cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-packagekit.pkla
[Netowrkmanager]
Identity=unix-group:sudo
Action=org.freedesktop.packagekit.system-sources-refresh
ResultAny=yes
ResultInactive=auth_admin
ResultActive=yes
EOF
sudo systemctl restart polkit
```

Ubuntu命令行注销桌面, 以便xrdp远程登录
```shell
gnome-session-quit --no-prompt
```