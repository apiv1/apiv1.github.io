### easyconnect in docker

启动
```shell
cp .env.example .env
vim .env
docker compose up -d
```

读取代理配置
```shell
# 获取MTU
export MTU=$(docker compose exec easyconnect cat /sys/class/net/tun0/mtu | tr -d '\r')
echo $MTU > mtu.txt
# 获取容器的主机IP
export HOST_IP=$(docker compose exec easyconnect ip addr | grep eth0 | awk '{print $2}' )
echo $HOST_IP > host_ip.txt

# 获取路由转发配置的IP, 保存(这个IP配置通常情况不会变, 如果变了重新存一下就行)
docker compose exec easyconnect ip route | grep tun0 | awk '{print $1}' | ( while read IP
do
  echo $IP
done ) > route_ip.txt
```

本机代理设置和删除
```shell
export MTU=$(cat mtu.txt)
export HOST_IP=$(cat host_ip.txt)
# 在本机(Linux)设置IP路由
cat route_ip.txt | while read IP
do
  ip route add $IP via $HOST_IP mtu $MTU
done

# 在本机(Linux)删除IP路由
cat route_ip.txt | while read IP
do
  ip route del $IP
done
```