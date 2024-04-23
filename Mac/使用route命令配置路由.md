### 配置路由

```shell
# 添加
SUB_NET=192.168.2.0/24
GATEWAY=192.168.1.1
route add -mtu 1400 $SUB_NET $GATEWAY

# 删除
route delete $SUB_NET
```