# 使用sslsplit抓包

* 安装软件
```shell
sudo apt-get install -y sslsplit iptables openssl ca-certificates procps
```

* 创建证书文件
```shell
mkdir -p ./cert
openssl genrsa -out ./cert/ca.key 4096
openssl req -new -x509 -days 3650 -key ./cert/ca.key -out ./cert/ca.crt -subj "/CN=SSLsplit Root CA"
```

* 设置转发
```shell
sysctl -w net.ipv4.ip_forward=1
```

* iptables 规则, 重定向数据
```shell
iptables -t nat -N SSLSPLIT

iptables -t nat -A PREROUTING -j SSLSPLIT

if [ -n "$INTERFACE" ]; then
  iptables -t nat -A SSLSPLIT -i $INTERFACE -p tcp --dport 443 -j REDIRECT --to-ports 8443
  iptables -t nat -A SSLSPLIT -i $INTERFACE -p tcp --dport 80 -j REDIRECT --to-ports 8080
else
  iptables -t nat -A SSLSPLIT -p tcp --dport 443 -j REDIRECT --to-ports 8443
  iptables -t nat -A SSLSPLIT -p tcp --dport 80 -j REDIRECT --to-ports 8080
fi
```

* 启动sshsplit
```shell
mkdir -p ./logs
sslsplit -D -l ./logs/connections.log -S ./logs -k ./cert/ca.key -c ./cert/ca.crt ssl 0.0.0.0 8443 tcp 0.0.0.0 8080
```

* 退出程序后, 清除 iptables 规则
```shell
iptables -t nat -D PREROUTING -j SSLSPLIT
iptables -t nat -F SSLSPLIT
iptables -t nat -X SSLSPLIT
```