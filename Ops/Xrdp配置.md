Linux配置xrdp: [https://docs.microsoft.com/zh-cn/azure/virtual-machines/linux/use-remote-desktop](https://docs.microsoft.com/zh-cn/azure/virtual-machines/linux/use-remote-desktop)

```bash
# 安装xfce4(可选)
sudo apt-get -y install xfce4
sudo apt install xfce4-session
echo xfce4-session >~/.xsession

# 安装
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
```

```bash
# 登录后不需要授权给管理器
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
