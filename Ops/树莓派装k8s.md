### 错误: failed to find memory cgroup
解决方法:
```
cgroup_enable=memory cgroup_memory=1
```
加到 `/boot/cmdline.txt` 然后重启