#!/bin/sh

test -n "$DISABLE_SSHD" && return 1

ssh-keygen -A
mkdir /var/run/sshd/
/usr/sbin/sshd -D -e ${SSHD_OPT}