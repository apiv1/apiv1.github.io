#!/bin/sh

docker rm -f vpn-pptp
docker run --rm -d --name vpn-pptp \
           --net=host \
           --privileged \
           -p 1723:1723 -p 1723:1723/udp \
           -e client=abc \
           -e server=* \
           -e password=123 \
           -e acceptable_local_ip_addresses=* \
           mmontagna/docker-vpn-pptp