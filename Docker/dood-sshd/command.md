### 直接从终端运行, 启动远程Docker服务

启动后可以ssh登录, 修改```~/.ssh/authorized_keys```添加密钥

#### Bash

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

groupadd --gid $PGID $SSHD_USERNAME
useradd --shell /bin/sh --uid $PUID --gid $PGID --password $(openssl passwd $SSHD_PASSWORD) --create-home --home-dir /home/$SSHD_USERNAME $SSHD_USERNAME
usermod -aG docker $SSHD_USERNAME

chown -R $SSHD_USERNAME:$SSHD_USERNAME /home/$SSHD_USERNAME
chown -R $SSHD_USERNAME:$SSHD_USERNAME /var/run/docker.sock

chmod 744 /home/$SSHD_USERNAME/.ssh
AUTH_KEY_FILE="/home/$SSHD_USERNAME/.ssh/authorized_keys"
test -f "$AUTH_KEY_FILE" && chmod 400 "$AUTH_KEY_FILE"

mkdir -p /etc/ssh/sshd_config.d
cat <<EOF > /etc/ssh/sshd_config.d/sshd.conf
PasswordAuthentication Yes
ListenAddress 0.0.0.0
EOF

exec /entrypoint.sh
'
```

#### Powershell

```powershell
docker rm -f dood-sshd

$SSHD_USERNAME='docker'
$SSHD_PASSWORD='passwd654321!'
$PGID='2000'
$PUID='2000'

$dockerSock = if ($null -ne $DOCKER_HOST -and ($null -eq $DOCKER_SOCK)) { $DOCKER_HOST.Replace('unix://', '') } else { $null }
$dockerSock = if (-not ($dockerSock)) { "/var/run/docker.sock" } else { $dockerSock }
docker run -d --name dood-sshd --restart always -e "PGID=${PGID}" -e "PUID=${PUID}" -v "${dockerSock}:/var/run/docker.sock:rw" -v dood-sshd_home_ssh:/home/docker/.ssh -v dood-sshd_ssh:/etc/ssh -p 2222:22 --entrypoint sh --init apiv1/sshd:docker -c ('
export SSHD_USERNAME="{0}"
export SSHD_PASSWORD="{1}"

groupadd --gid $PGID $SSHD_USERNAME
useradd --shell /bin/sh --uid $PUID --gid $PGID --password $(openssl passwd $SSHD_PASSWORD) --create-home --home-dir /home/$SSHD_USERNAME $SSHD_USERNAME
usermod -aG docker $SSHD_USERNAME

chown -R $SSHD_USERNAME:$SSHD_USERNAME /home/$SSHD_USERNAME
chown -R $SSHD_USERNAME:$SSHD_USERNAME /var/run/docker.sock

chmod 744 /home/$SSHD_USERNAME/.ssh
AUTH_KEY_FILE="/home/$SSHD_USERNAME/.ssh/authorized_keys"
test -f "$AUTH_KEY_FILE" && chmod 400 "$AUTH_KEY_FILE"

mkdir -p /etc/ssh/sshd_config.d
cat <<EOF > /etc/ssh/sshd_config.d/sshd.conf
PasswordAuthentication Yes
ListenAddress 0.0.0.0
EOF

exec /entrypoint.sh
' -f ${SSHD_USERNAME},${SSHD_PASSWORD} )
```