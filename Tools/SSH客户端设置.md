### 配置方法

~/.ssh/config
```
Host 服务器名A
    user 用户名
    hostname 服务器ip
    port 端口号
    identityfile 本地私钥地址
    ...
Host 服务器名B
    user 用户名
    hostname 服务器ip
    port 端口号
    identityfile 本地私钥地址
    ...
...
...
Host *
    ...
    ...
```

配置选项
* 必须配置
    * Host：指定配置块
    * User：指定登录用户
    * Hostname：指定服务器地址，通常用ip地址
    * Port：指定端口号，默认值为22
* 可选
    * Identityfile：指定本地认证私钥地址
    * ForwardAgent yes：允许ssh-agent转发
    * IdentitiesOnly：指定ssh是否仅使用配置文件或命令行指定的私钥文件进行认证。值为yes或no，默认为no，该情况可在ssh-agent提供了太多的认证文件时使用
    * IdentityFile：指定认证私钥文件
    * StrictHostKeyChecking：有3种选项
    * ask：默认值，第一次连接陌生服务器时提示是否添加，同时如果远程服务器公钥改变时拒绝连接
    * yes：不会自动添加服务器公钥到~/.ssh/known_hosts中，同时如果远程服务器公钥改变时拒绝连接
    * no：自动增加新的主机键到~/.ssh/known_hosts中


### 配置例子

配置文件

```shell
mkdir -p ~/.ssh && echo "
Host *
    ServerAliveInterval  60
    ServerAliveCountMax  60
    ConnectTimeout 30
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
">> ~/.ssh/config
chmod 400 ~/.ssh/config
```

使用alias
```shell
alias ssh="ssh \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=60 \
    -o ConnectTimeout=30 \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    "
```