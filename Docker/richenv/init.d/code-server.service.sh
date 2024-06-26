#!/bin/sh

test -n "$DISABLE_CODE_SERVER" && return 1

su - ${USERNAME} -c "PASSWORD='$CODE_SERVER_PASSWORD' \
HASHED_PASSWORD='$CODE_SERVER_HASHED_PASSWORD' \
CODE_SERVER_ARGS='$CODE_SERVER_ARGS' \
CODE_SERVER_PROXY_DOMAIN='$CODE_SERVER_PROXY_DOMAIN' \
CODE_SERVER_WORKSPACE='$CODE_SERVER_WORKSPACE' \
CODE_SERVER_BIND_ADDR='$CODE_SERVER_BIND_ADDR' \
/init.d/code-server.sh"