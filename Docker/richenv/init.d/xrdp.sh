#!/bin/sh

/usr/sbin/xrdp-sesman -k
/usr/sbin/xrdp -k

/usr/sbin/xrdp-sesman
/usr/sbin/xrdp ${XRDP_ARGS}
