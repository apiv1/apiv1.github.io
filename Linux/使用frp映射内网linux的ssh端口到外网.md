1. 需要一个VPS, 再就是一个内网里面的客户机 两个都是linux系统
1. 两个系统都装docker, 还有docker-compose得有
1. VPS配置: 建个文件夹, 执行几个命令, 会生成文件

**compose.yml**
```bash
cat <<EOF > compose.yml
services:
  frp:
    image: snowdreamtech/frps
    volumes:
      - ./frps.ini:/etc/frp/frps.ini
    network_mode: host
    restart: always
EOF
```
**frps.ini**
```bash
cat <<EOF > frps.ini
[common]
bind_port = 7000
bind_udp_port = 7000
token = abcdefg
EOF
```

4. 内网客户端配置: 也是建个文件夹 执行几个命令, 会生成文件

**compose.yml**
```yaml
cat <<EOF > compose.yml
services:
  frp:
    image: snowdreamtech/frpc
    volumes:
      - ./frpc.ini:/etc/frp/frpc.ini
    network_mode: host
    restart: always
EOF
```
**frpc.ini**
```bash
cat <<EOF > frpc.ini
[common]
server_addr = x.x.x.x # 这个地方写你自己的vps的ip
server_port = 7000
token = abcdefg

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

[ssh-xtcp]
type = xtcp
sk = ssh

local_ip = 127.0.0.1
local_port = 22

[rdp-xtcp]
type = xtcp
sk = rdp

local_ip = 127.0.0.1
local_port = 3389
EOF
```

5. VPS和客户机调用docker-compose -d  跑起来. 要停下来就调用docker-compose down. 他开机会随着docker自启动
6. ssh -p 6000 用户名@<VPS的ip> 就可以连ssh了
7. 使用xtcp连接

```bash
[common]
server_addr = x.x.x.x
server_port = 7000
token = abcdefg

[rdp-visitor]
type = xtcp
role = visitor
server_name = rdp-xtcp
sk = rdp
bind_addr = 127.0.0.1
bind_port = 3389

[p2p-ssh-visitor]
type = xtcp
role = visitor
server_name = main-ssh-xtcp
sk = ssh
bind_addr = 127.0.0.1
bind_port = 2222
```
