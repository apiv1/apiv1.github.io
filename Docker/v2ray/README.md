Server
```shell
docker run -d --name v2ray-server --restart always -p 32767:32767 -v $PWD/config.server.json:/etc/v2ray/config.json v2fly/v2fly-core run -c /etc/v2ray/config.json

docker run -d --name v2ray-server --restart always --network host -v $PWD/config.server.json:/etc/v2ray/config.json v2fly/v2fly-core run -c /etc/v2ray/config.json # linux
```

Client
```shell
docker run -d --name v2ray-client --restart always -p 1086:1086 -v $PWD/config.client.json:/etc/v2ray/config.json v2fly/v2fly-core

docker run -d --name v2ray-client --restart always --network host -v $PWD/config.client.json:/etc/v2ray/config.json v2fly/v2fly-core # linux
```