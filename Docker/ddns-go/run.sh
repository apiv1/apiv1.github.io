docker run -d --name ddns-go --restart=always -p 127.0.0.1:9876:9876 -v ddns-go-home:/root jeessy/ddns-go

# 重设密码
# docker exec ddns-go ./ddns-go -resetPassword 123456

# 本地端口映射到远端用于配置
# ssh  -L 9876:127.0.0.1:9876  <连接字串>