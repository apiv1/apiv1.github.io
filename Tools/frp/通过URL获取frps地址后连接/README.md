### frpc内网穿透

##### 原理: 自己在visitor主机运行frpc, 通过server主机运行的frps访问运行着frpc的proxy主机的端口

frps部署地址能通过url获取, 以应对frps部署在家用公网IP网络上**IP会变动的情况**.

需要部署3端:
* frps server端(必须是公网)
* frpc proxy端(目标内网)
* frpc visitor端(自己)

每端配置都新建一个文件夹 放入```compose.yml``` 和 ```.env```

#### 总配置文件
[.env.example](./.env.example) => ```.env```
* 公共部分
  * FRPS_BIND_PORT='' # 监听端口
  * FRPS_TOKEN='' # 密钥, 和其他端必须相同, 否则拒绝连接.
* proxy & visitor 共同配置
  - FRPC_SERVER_HOST_ADDR='' 配置frps网络地址, 如果ip不变可以直接写死ip
  - FRPC_SERVER_HOST_ADDR_FROM_URL='' 也可以通过设置请求某个自定义url返回server端ip进行连接
* proxy 配置
  * 可设置一个或多个 ```[[proxies]]``` 块 用于指定被访问的目标地址端口
* visitor 配置
  * 可设置一个或多个 ```[[visitors]]``` 块 用于指定proxy端映射到本机的目标地址端口

复制该文件为```.env```, 并编辑自己的配置, 对应端可以删除非自己这端的配置信息.

#### frps server 部署

文件夹内容
[frps.compose.yml](./frps.compose.yml) => ```compose.yml```
不用改

[.env.example](./.env.example) => ```.env```
需要
* 公共部分

#### frpc proxy 部署

文件夹内容
[visitors.frpc.compose.yml](./visitors.frpc.compose.yml) => ```compose.yml```
不用改

[.env.example](./.env.example) => ```.env```
需要
* 公共部分
* proxy & visitor 共同配置
* proxy 配置

#### frpc visitor 部署

文件夹内容
[visitors.frpc.compose.yml](./visitors.frpc.compose.yml) => ```compose.yml```
不用改

[visitors.frpc.compose.override.yml](./visitors.frpc.compose.override.yml) => ```compose.override.yml```
在service.frpc.ports 域需要自己配置 **映射到本地的端口**

[.env.example](./.env.example) => ```.env```
需要
* 公共部分
* proxy & visitor 共同配置
* visitor 配置
