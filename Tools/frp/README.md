# 端口映射穿透内网原理说明

### 角色
 - - -
**主机A,B**:
A需要和B通讯.

**visitor**:
主机A需要能够访问到visitor.
主机A主动给visitor发网络请求.
visitor收到网络请求, 会转而请求proxy.

**proxy**:
能接受visitor的请求, 按照请求发起和主机B的连接.
proxy需要能访问到主机B.
proxy主动给主机B发网络请求.
 - - -

##### 网络请求流程
```
visitor --------> proxy
 ^                   |
 |                   v
主机A               主机B
```

### visitor和proxy之间建立连接的方式
#### 服务中转型
 - - -
```
visitor ------> server <--------- proxy
```
visitor和proxy所在的机器都是内网机器, 无法被外网直接访问<br>所以他们需要主动对外网机器上的server发起连接, 建立数据通道<br>实现 visitor和proxy的通讯.

建立连接后**可简化为**
```
visitor <--------------> proxy
```
 - - -