### 直接从终端运行, 启动远程Dind服务

可以ssh登录到新启动的sshd服务, 修改```~/.ssh/authorized_keys```添加密钥,以便远程Dind使用

#### Bash

```shell
docker rm -f dind-sshd 2>/dev/null
docker run -d \
  --name dind-sshd \
  --hostname dind-sshd \
  --restart always \
  --privileged \
  -e PUID=${PUID:-$(id -u)} \
  -e PGID=${PGID:-$(id -g)} \
  -v dind-sshd_home:/home \
  -v dind-sshd_ssh:/etc/ssh \
  -v dind-sshd_dockerd:/dockerd \
  -p ${SSHD_PORT:-2022}:22 \
  --entrypoint sh \
  --init \
  apiv1/sshd:dockerd \
  -c '
export SSHD_USERNAME='${SSHD_USERNAME:-docker}'
export SSHD_PASSWORD='${SSHD_PASSWORD:-'passwd654321!'}'

groupadd --gid $PGID $SSHD_USERNAME
useradd --shell /bin/sh --uid $PUID --gid $PGID --password $(openssl passwd $SSHD_PASSWORD) --create-home --home-dir /home/$SSHD_USERNAME $SSHD_USERNAME
usermod -aG docker $SSHD_USERNAME

AUTH_KEY_FILE="/home/$SSHD_USERNAME/.ssh/authorized_keys"
test -f "$AUTH_KEY_FILE" && chmod 400 "$AUTH_KEY_FILE"

mkdir -p /etc/ssh/sshd_config.d
cat <<EOF > /etc/ssh/sshd_config.d/sshd.conf
PasswordAuthentication Yes
ListenAddress 0.0.0.0
EOF

export DOCKERD_OPT="--data-root /dockerd/lib/docker --exec-root /tmp/dockerd/run/docker -p /tmp/dockerd/run/docker.pid '${DOCKERD_OPT}'"
exec /entrypoint.sh
'
```

#### Powershell

```powershell
docker rm -f dind-sshd

$SSHD_USERNAME='docker'
$SSHD_PASSWORD='passwd654321!'
$SSHD_PORT='2022'
$PGID='2000'
$PUID='2000'

docker run -d --name dind-sshd --restart always --privileged -e "PGID=${PGID}" -e "PUID=${PUID}" -v dind-sshd_home:/home -v dind-sshd_ssh:/etc/ssh -v dind-sshd_dockerd:/dockerd -p "${SSHD_PORT}:22" --entrypoint sh --init apiv1/sshd:dockerd -c ('
export SSHD_USERNAME=\"{0}\"
export SSHD_PASSWORD=\"{1}\"
export DOCKERD_OPT=\"{2}\"

groupadd --gid $PGID $SSHD_USERNAME
useradd --shell /bin/sh --uid $PUID --gid $PGID --password $(openssl passwd $SSHD_PASSWORD) --create-home --home-dir /home/$SSHD_USERNAME $SSHD_USERNAME
usermod -aG docker $SSHD_USERNAME

AUTH_KEY_FILE="/home/$SSHD_USERNAME/.ssh/authorized_keys"
test -f "$AUTH_KEY_FILE" && chmod 400 "$AUTH_KEY_FILE"

mkdir -p /etc/ssh/sshd_config.d
cat <<EOF > /etc/ssh/sshd_config.d/sshd.conf
PasswordAuthentication Yes
ListenAddress 0.0.0.0
EOF

export DOCKERD_OPT=\"--data-root /dockerd/lib/docker --exec-root /tmp/dockerd/run/docker -p /tmp/dockerd/run/docker.pid $DOCKERD_OPT\"
exec /entrypoint.sh
' -f ${SSHD_USERNAME},${SSHD_PASSWORD},${DOCKERD_OPT} )
```