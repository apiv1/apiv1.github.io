### pptp-client
[ppp文档](https://tldp.org/HOWTO/PPP-HOWTO/index.html)
* [ip-up](https://tldp.org/HOWTO/PPP-HOWTO/x1455.html)

客户端: [pptp-client](https://pptpclient.sourceforge.net/)

### 启动
```shell
cp env.example .env
vim .env # 配置服务器,用户名,密码,虚拟子网路由等
docker compose up -d
```