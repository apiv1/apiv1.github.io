#!/bin/sh

set -e

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)

SERVICE_NAME=${SERVICE_NAME:-docker}
DOCKER_ARCH=${DOCKER_ARCH:-$(uname -m)}
case "$DOCKER_ARCH" in
arm64|armv8)
    DOCKER_ARCH=aarch64
    ;;
armv7l)
    DOCKER_ARCH=armhf
    ;;
*)
    ;;
esac

download_url() {
  URL=$1
  FILE=$2
  if command -v wget >/dev/null 2>&1; then
    local WGET_ARGS='--no-check-certificate --timeout=3 --tries=10'
    if test -n "$FILE"; then
      wget $WGET_ARGS -O $FILE $URL
    else
      wget $WGET_ARGS $URL
    fi
  elif command -v curl >/dev/null 2>&1; then
    local CURL_ARGS='-m 3 --retry 10 -sSLk'
    if test -n "$FILE"; then
      curl $CURL_ARGS -o $FILE $URL
    else
      curl $CURL_ARGS -O $URL
    fi
  fi
}

# Docker & Rootless install

dockerd_install () {
  if test ! -f "$SCRIPT_HOME/bin/dockerd" ; then
    local DOCKER_FILE_NAME=docker.tgz
    local DOWNLOAD_DOCKER_SITE=${DOWNLOAD_DOCKER_SITE:-https://download.docker.com}
    if test ! -f $DOCKER_FILE_NAME; then
      if test -z $DOCKER_DOWNLOAD_URL; then
        if test -z $DOCKER_VERSION; then
          echo query DOCKER_VERSION ...
          DOCKER_VERSION=$(download_url ${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ARCH}/ - | grep -e 'docker-[0-9]' | sed 's/^.*docker-//g' | sed 's/\.tgz.*$//g' | tail -1)
          test -z $DOCKER_VERSION && ( echo error: DOCKER_VERSION query failed ; return 1 )
        fi
        DOCKER_DOWNLOAD_URL=${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz
      fi
      download_url "${DOCKER_DOWNLOAD_URL}" ${DOCKER_FILE_NAME}
    fi
    tar zxvf ${DOCKER_FILE_NAME} && rm -rf ${DOCKER_FILE_NAME}

    mkdir -p bin
    mv docker/* bin/
    rmdir docker
  fi
}

dockerd_rootless_install () {
  local DOCKER_ROOTLESS_ARCH=$DOCKER_ARCH
  local DOCKER_ROOTLESS_VERSION=$DOCKER_VERSION

  if test ! -f "$SCRIPT_HOME/bin/dockerd-rootless.sh" ; then
    local DOCKER_ROOTLESS_FILE_NAME=docker-rootless-extras.tgz
    local DOWNLOAD_DOCKER_SITE=${DOWNLOAD_DOCKER_SITE:-https://download.docker.com}
    if test ! -f $DOCKER_ROOTLESS_FILE_NAME; then
      if test -z $DOCKER_ROOTLESS_DOWNLOAD_URL; then
        if test -z $DOCKER_ROOTLESS_VERSION; then
          echo query DOCKER_ROOTLESS_VERSION ...
          DOCKER_ROOTLESS_VERSION=$(download_url ${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ROOTLESS_ARCH}/ - | grep -e 'docker-rootless-extras-[0-9]' | sed 's/^.*docker-rootless-extras-//g' | sed 's/\.tgz.*$//g' | tail -1)
          test -z $DOCKER_ROOTLESS_VERSION && ( echo error: DOCKER_ROOTLESS_VERSION query failed ; return 1 )
        fi
        DOCKER_ROOTLESS_DOWNLOAD_URL=${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ROOTLESS_ARCH}/docker-rootless-extras-${DOCKER_ROOTLESS_VERSION}.tgz
      fi
      download_url "${DOCKER_ROOTLESS_DOWNLOAD_URL}" ${DOCKER_ROOTLESS_FILE_NAME}
    fi
    tar zxvf ${DOCKER_ROOTLESS_FILE_NAME} && rm -rf ${DOCKER_ROOTLESS_FILE_NAME}

    mkdir -p bin
    mv docker-rootless-extras/* bin/
    rmdir docker-rootless-extras
  fi
}

envrc_install_hint () {
echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.envrc

root user for root-dockerd, non-root user for dockerd-rootless

If use root dockerd in non-root user:
    USE_ROOT_DOCKERD=1 . '$SCRIPT_HOME'/.envrc
And:
  sudo sh -c "groupadd docker; usermod -aG docker ${USER}"
  # may need reboot host

dockerd-rootless:
  exec-root: ~/.local/share/docker/
  config-file: ~/.config/docker/daemon.json
'
}

dockerd_envrc_install () {
local DOCKER_UNIX_SOCK=unix:///tmp/${SERVICE_NAME}.sock
cat <<EOF > "$SCRIPT_HOME/.envrc"
export DOCKERD_HOME="$SCRIPT_HOME"

dockerd-load-envs() {
if test -n "\$USE_ROOT_DOCKERD" -o "\$(id -u)" = "0"; then
  export DOCKER_HOST="$DOCKER_UNIX_SOCK"
else
  if test ! -w "\$XDG_RUNTIME_DIR"; then
    echo "dockerd-load-envs: ERROR: XDG_RUNTIME_DIR needs to be set and writable"
    return 1
  else
    export DOCKER_HOST="unix://\${XDG_RUNTIME_DIR}/docker.sock"
  fi
fi
test -n "\$DOCKER_HOST" && export DOCKER_SOCK=\${DOCKER_HOST//unix:\/\//}
export PATH="\$DOCKERD_HOME/bin:\$PATH"

local ENV_PATH="\$DOCKERD_HOME/.envrc.d"
for item in \$(ls -A \${ENV_PATH} 2>/dev/null)
do
  . "\$ENV_PATH/\$item"
done
}
dockerd-load-envs

export DOCKERD_SERVICE_SH="$(realpath $0)"
dockerd-service () {
  sh \$DOCKERD_SERVICE_SH \$*
}

EOF
}

# System Service
dockerd_service_install () {
local DOCKER_SERVICE_FILE="${DOCKER_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}"
if test -f "$DOCKER_SERVICE_FILE" ; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  return 1
fi

local DOCKER_UNIX_SOCK=unix:///tmp/${SERVICE_NAME}.sock
local DOCKERD_TMP_DIR=/tmp/${SERVICE_NAME}
local DOCKER_BIN="$SCRIPT_HOME/bin"
local DOCKERD_ARGS='-H '$DOCKER_UNIX_SOCK' --exec-root '$DOCKERD_TMP_DIR'/run/docker -p '$DOCKERD_TMP_DIR'/run/docker.pid --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/docker'

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
EnvironmentFile=-'$SCRIPT_HOME'/.envrc
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
' > "$DOCKER_SERVICE_FILE"

chmod +x "$DOCKER_SERVICE_FILE"

systemctl daemon-reload
systemctl start "$SERVICE_NAME"
systemctl enable "$SERVICE_NAME".service
systemctl status --no-pager "$SERVICE_NAME"
}

dockerd_service_uninstall () {
  local DOCKER_SERVICE_FILE="${DOCKER_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}"

  systemctl stop "$SERVICE_NAME"
  systemctl disable "$SERVICE_NAME".service
  rm "$DOCKER_SERVICE_FILE"
}

dockerd_rootless_service_install () {
  PATH=$PATH:"$SCRIPT_HOME/bin"
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh uninstall
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh install
}

dockerd_rootless_service_uninstall () {
  PATH=$PATH:"$SCRIPT_HOME/bin"
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh uninstall
}

test "$(id -u)" = "0" && export IS_ROOT=1

if test "$#" -lt 1; then
  echo "usage: <install|install-rootless|up|down|envrc|hint>"
  exit 1
fi

ACTION=$1
case $ACTION in
install)
  dockerd_install
  dockerd_envrc_install
  envrc_install_hint
  ;;
install-rootless)
  dockerd_install
  dockerd_rootless_install
  dockerd_envrc_install
  envrc_install_hint
  ;;
up)
  if test -n "$IS_ROOT"; then
    dockerd_install
    dockerd_service_install
  else
    dockerd_install
    dockerd_rootless_install
    dockerd_rootless_service_install
  fi
  envrc_install_hint
  ;;
down)
  if test -n "$IS_ROOT"; then
    dockerd_service_uninstall
  else
    dockerd_rootless_service_uninstall
  fi
  ;;
envrc)
  dockerd_envrc_install
  ;;
hint)
  envrc_install_hint
  ;;
*)
  echo "command '$ACTION' not found"
  ;;
esac
