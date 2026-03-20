#### sudo不用输入密码
```shell
sudo sh -c 'file="/etc/sudoers.d/99-nopasswd-$SUDO_USER"; echo "$SUDO_USER ALL=(ALL) NOPASSWD:ALL" > "$file" && chmod 440 "$file" && visudo -c'
```

#### 取消免密
```shell
sudo sh -c 'file="/etc/sudoers.d/99-nopasswd-$SUDO_USER";  rm -f "$file" && visudo -c'
```