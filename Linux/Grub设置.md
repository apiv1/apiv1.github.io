### Grub设置
/etc/default/grub
```shell
# Grub下次的启动项设为默认
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true

GRUB_TIMEOUT_STYLE=menu  # 显示菜单
GRUB_TIMEOUT=10   # 超时时间10秒
GRUB_DISABLE_OS_PROBER=false   # 允许os探测
```
更新
```shell
update-grub
```
