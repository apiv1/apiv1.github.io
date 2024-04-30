### 通过公用STUN服务器检查NAT类型

**对称性NAT(Symmetric NAT) 无法打洞**.
* [stun 客户端: go-stun](https://github.com/ccding/go-stun)
* [NAT类型说明](./NAT类型说明.md)
* [公用STUN服务器列表](./公用STUN服务器列表.md)

具体操作:
```shell
# 安装

# golang环境自行安装
# go package安装路径需要自行配置, 如果没配置, 使用go install安装的命令会提示找不到命令.
go install github.com/ccding/go-stun@latest

# 使用
go-stun -v -s stun.voip.aebc.com:3478 # 公用STUN服务器列表里找一个, 默认端口是3478, 这个工具里需要显式指定.
```