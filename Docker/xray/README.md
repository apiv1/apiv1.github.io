```shell
docker run -d --name xray-client --restart always -p 1086:1086 -p 1080:1080 -v $PWD/config.client.json:/etc/xray/config.json teddysun/xray xray run -c /etc/xray/config.json
```