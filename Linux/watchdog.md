### 软看门狗，外部如果定时连接失败则重启。

#### 目标机
watchdog.sh
```shell
#!/bin/sh

UID=${UID:-$(id -u)}
test $UID -eq 0 || ( echo 'need root'; exit 1 )

export PID_FILE=/tmp/watchdog.pid
export WATCHDOG_PID=$(cat "$PID_FILE" 2>/dev/null)
export TIMEOUT=${1:-300}

test -n "$WATCHDOG_PID" && pkill -P "$WATCHDOG_PID"
echo "reboot after ${TIMEOUT}"
(sleep $TIMEOUT && systemctl reboot) &
echo $! > "$PID_FILE"
```

#### 监控机
watcher.sh
```shell
#!/bin/sh
SSH_URL=""
SSH_KEY_FILE=""
TIMEOUT=""

ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=60 -o ConnectTimeout=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "$SSH_KEY_FILE" "$SSH_URL" ~/watchdog.sh $TIMEOUT &

SSH_PID=$!
sleep 10 && pkill -P $SSH_PID
```

监控机安装定时任务
```shell
(crontab -l; echo "*/3 * * * * $HOME/watcher.sh") | crontab -
```