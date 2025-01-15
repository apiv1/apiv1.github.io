#### 本地端口映射到远端
```shell
ssh -L 8080:localhost:80 -N user@remote-server
```

#### 远程端口映射到本机
```shell
ssh -R 8080:localhost:80 user@example.com -N
```

#### SOCKS服务转发
```shell
ssh -D 5500 user@example.com -N
```

说明
* -L 本地端口映射
* -R 远程端口映射
* -N 不执行命令, 只做端口映射
* -D 启动一个 SOCKS 代理服务器, 把数据从远程服务器发出