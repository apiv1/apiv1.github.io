#!/bin/sh

set -e

DOCKER_SERVICE_FILE=${DOCKER_SERVICE_FILE:-/etc/systemd/system/docker.service}
DOCKER_VERSION=${DOCKER_VERSION:-20.10.7}
DOCKER_DOWNLOAD_URL=${DOCKER_DOWNLOAD_URL:-https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz}

if [ -f "$DOCKER_SERVICE_FILE" ]; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
if [ ! -f "$SCRIPT_HOME/docker/dockerd" ]; then
    wget "${DOCKER_DOWNLOAD_URL}"
    tar zxvf docker-${DOCKER_VERSION}.tgz && rm -rf docker-${DOCKER_VERSION}.tgz
fi

DOCKER_BIN="$SCRIPT_HOME/docker"
DOCKERD_ARGS='-H unix://'$SCRIPT_HOME'/run/docker.sock --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/docker  --exec-root '$SCRIPT_HOME'/run/docker -p '$SCRIPT_HOME'/run/docker.pid'

if [ ! -f "$SCRIPT_HOME/daemon.json" ]; then
cat <<EOF > "$SCRIPT_HOME/daemon.json"
{
}
EOF
fi

echo '
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com

[Service]
Type=notify
Environment="PATH='$DOCKER_BIN':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart='$DOCKER_BIN'/dockerd '$DOCKERD_ARGS'
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
' > $DOCKER_SERVICE_FILE

chmod +x $DOCKER_SERVICE_FILE

systemctl daemon-reload
systemctl start docker
systemctl enable docker.service
systemctl status --no-pager -l docker

if [ ! -f "$SCRIPT_HOME/.env" ]; then
cat <<EOF > "$SCRIPT_HOME/.env"
SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
export PATH="\$SCRIPT_HOME/docker:\$PATH"
export DOCKER_HOST="unix://\$SCRIPT_HOME/run/docker.sock"
EOF
fi

echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.env
'