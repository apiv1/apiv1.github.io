#!/bin/bash

if test $# -eq 2
then
    proxy_ip=$1
    proxy_port=$2
else
    echo "No proxy URL defined. exit"
    exit 1
fi

echo "Creating redsocks configuration file using proxy ${proxy_ip}:${proxy_port}..."
sed -e "s|\${proxy_ip}|${proxy_ip}|" \
    -e "s|\${proxy_port}|${proxy_port}|" \
    /etc/redsocks.tmpl > /tmp/redsocks.conf

echo "Generated configuration:"
cat /tmp/redsocks.conf

if test -n "$START_FW" ; then
    echo "Activating iptables rules..."
    /usr/local/bin/redsocks-fw.sh start
fi

echo "Starting redsocks..."
/usr/sbin/redsocks -c /tmp/redsocks.conf