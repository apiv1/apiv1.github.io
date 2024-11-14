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

# with token
IP_ECHO_TOKEN="fKkSUGb5YUhmhciY"
docker run -d --restart always --name ip-echo --network host -e TOKEN=${IP_ECHO_TOKEN} apiv1/ip-echo

# update ip
IP_ECHO_UPDATE_BASE_URL="http://x.x.x.x"
IP_ECHO_UPDATE_CODE="xXK740LZuors3OPp" # your update code (unique)
IP_ECHO_UPDATE_URL="${IP_ECHO_UPDATE_BASE_URL}/?update_ip=${IP_ECHO_UPDATE_CODE}&token=${IP_ECHO_TOKEN}"
docker run -d --name ip-echo-update --restart always -it netdata/wget sh -c 'while true; do wget --timeout 2 -qO - "'${IP_ECHO_UPDATE_URL}'"; echo; sleep 16; done'

# get updated ip
IP_ECHO_GET_URL="${IP_ECHO_UPDATE_BASE_URL}/?get_ip=${IP_ECHO_UPDATE_CODE}"
wget -qO - "$IP_ECHO_GET_URL"

# update redirect
IP_ECHO_UPDATE_BASE_URL="http://x.x.x.x"
UPDATE_REDIRECT_CODE="Ewa5bSoN1HB1W6HG" # your update code (unique)
REDIRECT_URL='https://$MY_IP/api'
UPDATE_REDIRECT_URL="${IP_ECHO_UPDATE_BASE_URL}/?update_redirect=${UPDATE_REDIRECT_CODE}&url=${REDIRECT_URL}&token=${IP_ECHO_TOKEN}"
docker run -d --name ip-echo-update --restart always -it netdata/wget sh -c 'while true; do wget --timeout 2 -qO - "'${UPDATE_REDIRECT_URL}'"; echo; sleep 16; done'

# get redirect ip
GET_REDIRECT_URL="${IP_ECHO_UPDATE_BASE_URL}/?get_redirect=${UPDATE_REDIRECT_CODE}"
wget -qO - "$GET_REDIRECT_URL"
```