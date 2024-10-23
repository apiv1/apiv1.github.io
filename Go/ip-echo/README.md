### build
```bash
docker build . --build-arg APP_NAME=ip-echo -t apiv1/ip-echo
docker buildx build . --build-arg APP_NAME=ip-echo --platform linux/amd64,linux/arm64 --push -t apiv1/ip-echo # buildkit
```

### run
```bash
docker run --rm -p 8089:8089 apiv1/ip-echo
docker run --rm --network host apiv1/ip-echo

docker run -d --restart always --name ip-echo -p 8089:8089 apiv1/ip-echo
docker run -d --restart always --name ip-echo --network host apiv1/ip-echo
```

### update ip
```bash
IP_ECHO_UPDATE_BASE_URL="http://x.x.x.x"
IP_ECHO_UPDATE_CODE="xXK740LZuors3OPp" # your update code (unique)
IP_ECHO_TOKEN="fKkSUGb5YUhmhciY"
IP_ECHO_UPDATE_URL="${IP_ECHO_UPDATE_BASE_URL}/?update_ip=${IP_ECHO_UPDATE_CODE}&token=${IP_ECHO_TOKEN}"
docker run -d --name ip-echo-update --restart always -it netdata/wget sh -c "while true; do wget --timeout 1 -qO - $IP_ECHO_UPDATE_URL; sleep 15; done"

# get updated ip
wget -qO - "$IP_ECHO_UPDATE_URL"
```