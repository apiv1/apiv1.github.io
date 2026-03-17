### sysrq
system request， 紧急控制接口。可以实现强制关机重启。

#### sysrq位掩码
/proc/sys/kernel/sysrq 是一个位掩码，每一位控制一类功能是否允许：
```
十进制位	十六进制	含义
1	0x01	允许 sync (s)
2	0x02	允许 remount 只读 (u)
4	0x04	允许发 SIGTERM (e)
8	0x08	允许发 SIGKILL (i)
16	0x10	允许 dump 进程/内存等 (p, t 等)
32	0x20	允许修改终端 (k)
64	0x40	允许修改 nice/调度 (n)
128	0x80	允许重启/关机 (b, o)
```
#### sysrq控制字符
```
写入的字符	含义	典型用法
b	立即重启（boot）	系统卡死时强制重启
s	sync：把缓存刷到磁盘	怕数据没写完时先 echo s 再 echo b
u	把已挂载文件系统只读化（unmount 的简化）	配合 s、b 做“尽量安全”的强制重启
o	关机（power off）	想直接断电而不是重启时用
e	向除 init 外的进程发 SIGTERM	温和一点“清场”，可能仍会卡在 D 状态
i	向除 init 外的进程发 SIGKILL	比 e 更狠，D 状态仍然杀不掉
c	触发内核 panic（若配置了 kdump 会抓 vmcore）	做崩溃转储用，不是日常重启
```
#### 使用方法
查看位掩码，判断是否可用
```shell
cat /proc/sys/kernel/sysrq
```
设置位掩码，使控制字符可用
```shell
sudo sysctl -w kernel.sysrq=128
```
写入字符实现控制
```shell
sudo sh -c 'echo b > /proc/sysrq-trigger'
# 或者
echo b | sudo tee /proc/sysrq-trigger
```

组合重启命令
```shell
sudo sh -c 'sysctl -w kernel.sysrq=128; echo b > /proc/sysrq-trigger'
```