#!/bin/sh

random() {
    cat /dev/urandom | base64 | tr -dc '_A-Za-z0-9' | head -c 15
}

set +e

# Create the user account
export USERNAME=${USERNAME:-user}
export PASSWORD=${PASSWORD:-$(random)}

echo 'USERNAME='${USERNAME}
echo 'PASSWORD='${PASSWORD}

export PGID=${PGID:-2000}
export PUID=${PUID:-2000}
groupadd --gid ${PGID} ${USERNAME}
useradd --shell /bin/bash --uid ${PUID} --gid ${PGID} --password $(openssl passwd ${PASSWORD}) --create-home --home-dir /home/${USERNAME} ${USERNAME}
usermod -aG sudo ${USERNAME}

groupadd docker
usermod -aG docker ${USERNAME}

set -e

test -n "$*" && $*

test -z "$DISABLE_CODE_SERVER" && su - ${USERNAME} -c "PASSWORD='$CODE_SERVER_PASSWORD' \
HASHED_PASSWORD='$CODE_SERVER_HASHED_PASSWORD' \
CODE_SERVER_ARGS='$CODE_SERVER_ARGS' \
CODE_SERVER_PROXY_DOMAIN='$CODE_SERVER_PROXY_DOMAIN' \
CODE_SERVER_WORKSPACE='$CODE_SERVER_WORKSPACE' \
CODE_SERVER_BIND_ADDR='$CODE_SERVER_BIND_ADDR' \
/init.d/code-server.sh" &
test -z "$DISABLE_XRDP" && /init.d/xrdp.sh &
test -z "$DISABLE_SSHD" && /init.d/sshd.sh &
test -z "$DISABLE_DOCKERD" && /init.d/dockerd.sh &

sleep infinity