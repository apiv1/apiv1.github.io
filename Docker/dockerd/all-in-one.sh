#!/bin/sh

set -e

SERVICE_NAME=docker
DOCKER_SERVICE_FILE=${DOCKER_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)

echo '
  systemctl stop '$SERVICE_NAME'
  systemctl disable '$SERVICE_NAME'.service
  rm '$DOCKER_SERVICE_FILE'
' > $SCRIPT_HOME/uninstall.sh
chmod +x $SCRIPT_HOME/uninstall.sh

if test -f "$DOCKER_SERVICE_FILE" ; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

if test ! -f "$SCRIPT_HOME/docker/dockerd" ; then
  if test -z $DOCKER_DOWNLOAD_URL; then
    DOCKER_ARCH=${DOCKER_ARCH:-$(arch)}
    case "$DOCKER_ARCH" in
    arm64)
        DOCKER_ARCH=aarch64
        ;;
    *)
        ;;
    esac
    if test -z $DOCKER_VERSION; then
      echo query DOCKER_VERSION ...
      DOCKER_VERSION=$(wget -qO - https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/ | grep -e 'docker-[0-9]' | sed 's/^.*docker-//g' | sed 's/\.tgz.*$//g' | tail -1)
      test -z $DOCKER_VERSION && ( echo error: DOCKER_VERSION query failed ; exit 1 )
    fi
    DOCKER_DOWNLOAD_URL=https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz
  fi
  DOCKER_FILE_NAME=docker.tgz
  wget -O ${DOCKER_FILE_NAME} "${DOCKER_DOWNLOAD_URL}"
  tar zxvf ${DOCKER_FILE_NAME} && rm -rf ${DOCKER_FILE_NAME}
fi

DOCKER_UNIX_SOCK=unix:///tmp/dockerd.sock
DOCKERD_TMP_DIR=/tmp/dockerd
DOCKER_BIN="$SCRIPT_HOME/docker"
DOCKERD_ARGS='-H '$DOCKER_UNIX_SOCK' --exec-root '$DOCKERD_TMP_DIR'/run/docker -p '$DOCKERD_TMP_DIR'/run/docker.pid --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/docker'

if test ! -f "$SCRIPT_HOME/daemon.json" ; then
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
User=root
Group=root
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

if test ! -f "$SCRIPT_HOME/.env" ; then
cat <<EOF > "$SCRIPT_HOME/.env"
SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
export PATH="\$SCRIPT_HOME/docker:\$PATH"
export DOCKER_HOST="$DOCKER_UNIX_SOCK"
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