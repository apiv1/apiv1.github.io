配置: [Xray-examples](https://github.com/XTLS/Xray-examples)

### 启动客户端

文件放在 config.client.json

docker
```shell
docker run -d --name xray-client --restart always -p 3128:3128 -p 1080:1080 -v $PWD/config.client.json:/etc/xray/config.json teddysun/xray xray run -c /etc/xray/config.json
```

#### docker-compose
启动xray
```shell
docker-compose up -d xray
```

启动xray并启动[redsocks](../redsocks/README.md)为docker内网提供全局代理
```
docker-compose up -d xray redsocks
```