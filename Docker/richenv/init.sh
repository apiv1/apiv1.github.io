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

for item in `ls /init.d/*.service.sh 2>/dev/null`
do
    ($item && echo "launching $item...")&
done

for item in `ls /init.d/*.rc.sh 2>/dev/null`
do
    . $item && echo "loading $item..."
done

test -n "$*" && $*

sleep infinity