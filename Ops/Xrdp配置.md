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
