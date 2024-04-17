#!/bin/sh

export USERNAME=${USERNAME:-docker}

groupadd --gid ${PGID} ${USERNAME}
usermod -aG docker ${USERNAME}

chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
test -f /home/${USERNAME}/.ssh/authorized_keys && chmod 400 /home/${USERNAME}/.ssh/authorized_keys

su - ${USERNAME} -c "PASSWORD='$CODE_SERVER_PASSWORD' \
HASHED_PASSWORD='$CODE_SERVER_HASHED_PASSWORD' \
CODE_SERVER_ARGS='$CODE_SERVER_ARGS' \
CODE_SERVER_PROXY_DOMAIN='$CODE_SERVER_PROXY_DOMAIN' \
CODE_SERVER_WORKSPACE='$CODE_SERVER_WORKSPACE' \
CODE_SERVER_BIND_ADDR='$CODE_SERVER_BIND_ADDR' \
sh /init.d/code-server.sh" &
/init.d/docker.sh