找到docker.service文件, 加这两行

```
[Service]
...
Environment="HTTP_PROXY=socks5://localhost:8964/"
Environment="NO_PROXY=localhost,127.0.0.1,registry-1.docker.io"
```
