```shell
docker rm -f dood-sshd 2>/dev/null
docker run -d \
  --name dood-sshd \
  --restart always \
  -e PUID=${PUID:-2000} \
  -e PGID=${PGID:-2000} \
  -v ${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock:rw \
  -v dood-sshd_home_ssh:/home/docker/.ssh \
  -v dood-sshd_ssh:/etc/ssh \
  -p 2222:22 \
  --entrypoint sh \
  --init \
  apiv1/sshd:docker \
  -c '
    export SSHD_USERNAME='${SSHD_USERNAME:-docker}'
    export SSHD_PASSWORD='${SSHD_PASSWORD:-'passwd654321!'}'
    groupadd --gid $PGID $SSHD_USERNAME && \
    useradd --shell /bin/sh --uid $PUID --gid $PGID --password $(openssl passwd $SSHD_PASSWORD) --create-home --home-dir /home/$SSHD_USERNAME $SSHD_USERNAME && \
    usermod -aG docker $SSHD_USERNAME && \
    chown -R $SSHD_USERNAME:$SSHD_USERNAME /home/$SSHD_USERNAME && \
    chown -R $SSHD_USERNAME:$SSHD_USERNAME /var/run/docker.sock && \
    chmod 744 /home/$SSHD_USERNAME/.ssh && \
    AUTH_KEY_FILE="/home/$SSHD_USERNAME/.ssh/authorized_keys" && \
    test -f "$AUTH_KEY_FILE" && chmod 400 "$AUTH_KEY_FILE" && \
    mkdir -p /etc/ssh/sshd_config.d
    printf "PasswordAuthentication Yes\nListenAddress 0.0.0.0\n" > /etc/ssh/sshd_config.d/sshd.conf
    exec /entrypoint.sh
  '
```