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
创建好了后在设备上把ca.crt安装一下就能抓明文https

* [iptables 规则, 重定向数据](../Linux/iptables.md#重定向数据)

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