```bash
# 安装netstat
apt install -y net-tools
# 查看一次
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
# 循环查看
while true; do netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'; sleep 1; clear; done
```
