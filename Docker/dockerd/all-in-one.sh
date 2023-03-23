#!/bin/sh

set -e

SERVICE_NAME=docker
DOCKER_SERVICE_FILE=${DOCKER_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}
DOCKER_VERSION=${DOCKER_VERSION:-23.0.1}
DOCKER_ARCH=${DOCKER_ARCH:-$(arch)}
DOCKER_DOWNLOAD_URL=${DOCKER_DOWNLOAD_URL:-https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz}

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)

echo '
  systemctl stop '$SERVICE_NAME'
  systemctl disable '$SERVICE_NAME'.service
  rm '$DOCKER_SERVICE_FILE'
' > $SCRIPT_HOME/uninstall.sh
chmod +x $SCRIPT_HOME/uninstall.sh

if [ -f "$DOCKER_SERVICE_FILE" ]; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

if [ ! -f "$SCRIPT_HOME/docker/dockerd" ]; then
    wget "${DOCKER_DOWNLOAD_URL}"
    tar zxvf docker-${DOCKER_VERSION}.tgz && rm -rf docker-${DOCKER_VERSION}.tgz
fi

DOCKERD_TMP_DIR=/tmp/dockerd
DOCKER_BIN="$SCRIPT_HOME/docker"
DOCKERD_ARGS='-H unix://'$DOCKERD_TMP_DIR'/run/docker.sock --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/docker  --exec-root '$SCRIPT_HOME'/run/docker -p '$DOCKERD_TMP_DIR'/run/docker.pid'

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

if [ ! -f "$SCRIPT_HOME/.env" ]; then
cat <<EOF > "$SCRIPT_HOME/.env"
SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
export PATH="\$SCRIPT_HOME/docker:\$PATH"
export DOCKER_HOST="unix://\$DOCKERD_TMP_DIR/run/docker.sock"
EOF
fi

echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.env
'

systemctl daemon-reload
systemctl start docker
systemctl enable docker.service
systemctl status --no-pager -l docker