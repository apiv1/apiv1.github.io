### 创建网桥

```shell
docker network create -d bridge --subnet=10.1.1.0/24 --gateway=10.1.1.254 -o "com.docker.network.bridge.name=brlan" brlan
```

### 创建软路由

#### 启动
```shell
docker run -d --restart always --name immortalwrt --network brlan --privileged -v immortalwrt-config:/etc/config -v /lib/modules:/lib/modules --entrypoint /sbin/init immortalwrt:current
```

#### 旁路由设置

* ip设置为10.1.1.1, 网关是10.1.1.254

/etc/config/network
```
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth0'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '10.1.1.1'
	option gateway '10.1.1.254'
	option netmask '255.255.255.0'
	option ip6assign '60'
	list dns '10.1.1.254'
	list dns '114.114.114.114'
	list dns '8.8.8.8
```

执行命令
```shell
docker exec -it immortalwrt sh
vi /etc/config/network # 设置上面的文件
/etc/init.d/network restart # 重启网络
```

#### 软路由配置
```shell
# 更新到镜像
docker commit immortalwrt immortalwrt:current

# 还原初始配置
docker tag immortalwrt:base immortalwrt:current
```

#### 删除软路由
```shell
docker rm -f immortalwrt
```

#### 删除网桥
```shell
docker network rm brlan
```