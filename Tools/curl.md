获取重定向url
```shell
curl -Ls -w %{url_effective} -o /dev/null $URL
```