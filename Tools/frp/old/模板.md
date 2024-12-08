### frp模板

frps
```bash
PORT=''
TOKEN=''

FRP_INI_NAME=$(cat /dev/urandom | base64 | tr -dc '_A-Za-z0-9' | head -c 15)
FRP_INI_FILE=/tmp/$FRP_INI_NAME-frps.ini
cat <<EOF > $FRP_INI_FILE
[common]
bind_port = $PORT
bind_udp_port = $PORT
token = $TOKEN
EOF
docker run --name frps -d -v $FRP_INI_FILE:/frps.ini -p $PORT:$PORT -p $PORT:$PORT/udp --entrypoint frps snowdreamtech/frps -c /frps.ini
```

frpc: xtcp
```bash
SERVER_ADDR=''
SERVER_PORT=''
TOKEN=''
SERVER_NAME=''
SERVER_SK=''
PORT=''

FRP_INI_NAME=$(cat /dev/urandom | base64 | tr -dc '_A-Za-z0-9' | head -c 15)
FRP_INI_FILE=/tmp/$FRP_INI_NAME-frpc.ini

# visitor
cat <<EOF > $FRP_INI_FILE
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT
token = $TOKEN

[$SERVER_NAME]
type = xtcp
role = visitor
server_name = $SERVER_NAME
sk = $SERVER_SK
bind_addr = 0.0.0.0
bind_port = $PORT
EOF

# server
cat <<EOF > $FRP_INI_FILE
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT
token = $TOKEN

[$SERVER_NAME]
type = xtcp
sk = $SERVER_SK
local_ip = 127.0.0.1
local_port = $PORT
EOF

docker run --name frpc -d -v $FRP_INI_FILE:/frpc.ini -p $PORT:$PORT --entrypoint frpc snowdreamtech/frpc -c /frpc.ini
```