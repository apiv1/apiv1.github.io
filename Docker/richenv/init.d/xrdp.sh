#!/bin/sh

/usr/sbin/xrdp-sesman -k
/usr/sbin/xrdp -k
rm -rf /run/xrdp/xrdp.pid /run/xrdp/xrdp-sesman.pid

/usr/sbin/xrdp-sesman
/usr/sbin/xrdp ${XRDP_ARGS}
