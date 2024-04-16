#!/bin/sh

random() {
    cat /dev/urandom | base64 | tr -dc '_A-Za-z0-9' | head -c 15
}

# Create the user account
export USERNAME=${USERNAME:-user}
export PASSWORD=${PASSWORD:-$(random)}

echo 'USERNAME='${USERNAME}
echo 'PASSWORD='${PASSWORD}

groupadd --gid 1020 ${USERNAME}
useradd --shell /bin/bash --uid 1020 --gid 1020 --password $(openssl passwd ${PASSWORD}) --create-home --home-dir /home/${USERNAME} ${USERNAME}
usermod -aG sudo ${USERNAME}

# Start xrdp sesman service
/usr/sbin/xrdp-sesman

XRDP="/usr/sbin/xrdp ${XRDP_ARGS}"

# Run xrdp in foreground if no commands specified
if [ -z "$@" ]; then
    ${XRDP} --nodaemon
else
    ${XRDP}
    exec "$@"
fi
