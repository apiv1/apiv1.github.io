获取重定向url
```shell
curl -Ls -w %{url_effective} -o /dev/null $URL
```

发post请求
```shell
curl -H "Content-Type: application/json" -X POST -d '{"user_id": "123", "coin":100, "success":1, "msg":"OK!" }' "http://192.168.0.1:8001/test"
```