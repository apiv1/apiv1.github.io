
```bash
# 服务端
docker run -d --restart always --name ss-server -p 1080:1080 shadowsocks/shadowsocks-libev ss-server -s 0.0.0.0 -p 1080 -k ${SS_PASSWD:-passwd} -m chacha20-ietf-poly1305 -u

# 客户端
docker run -d --restart always --name ss-local -p 1080:1080 shadowsocks/shadowsocks-libev ss-local -s $SS_SERVER -p ${SS_SERVER_PORT:-1080} -b 0.0.0.0 -l 1080 -k ${SS_PASSWD:-passwd} -m chacha20-ietf-poly1305 -u
```