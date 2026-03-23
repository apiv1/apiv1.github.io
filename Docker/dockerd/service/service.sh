#!/bin/sh

set -e

export SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)

export SERVICE_NAME=${SERVICE_NAME:-docker}
export DOCKER_ARCH=${DOCKER_ARCH:-$(uname -m)}
case "$DOCKER_ARCH" in
arm64|armv8)
    export DOCKER_ARCH=aarch64
    ;;
armv7l)
    export DOCKER_ARCH=armhf
    ;;
*)
    ;;
esac

download_url() {
  URL=$1
  FILE=$2
  if command -v wget >/dev/null 2>&1; then
    local WGET_ARGS='--no-check-certificate --timeout=10 --tries=10'
    if test -n "$FILE"; then
      wget $WGET_ARGS -O $FILE $URL
    else
      wget $WGET_ARGS $URL
    fi
  elif command -v curl >/dev/null 2>&1; then
    local CURL_ARGS='-m 10 --retry 10 -sSLk'
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
    cd $SCRIPT_HOME
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
    cd -
  fi
}

dockerd_rootless_install () {
  local DOCKER_ROOTLESS_ARCH=$DOCKER_ARCH
  local DOCKER_ROOTLESS_VERSION=$DOCKER_VERSION

  if test ! -f "$SCRIPT_HOME/bin/dockerd-rootless.sh" ; then
    cd $SCRIPT_HOME
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
    cd -
  fi
}

envrc_install_hint () {
echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.envrc

If use root dockerd in non-root user:
  sudo sh -c "groupadd docker; usermod -aG docker ${USER}"
  sudo systemctl restart docker

  # enable now
  newgrp docker # shell temporary
  pkill X # restart X-session
  sudo reboot # reboot host
  exit # ssh relogin

For dockerd-rootless on non-root user,
Put it into your shell rc file:
    USE_ROOTLESS_DOCKERD=1 . '$SCRIPT_HOME'/.envrc
dockerd-rootless:
  exec-root: ~/.local/share/docker/
  config-file: ~/.config/docker/daemon.json
'
}

dockerd_envrc_install () {
if test -f "$SCRIPT_HOME/.envrc"; then
  echo "info: '$SCRIPT_HOME/.envrc' already exists, skip rewriting"
  return 0
fi

cat <<EOF > "$SCRIPT_HOME/.envrc"
export DOCKERD_HOME="$SCRIPT_HOME"
export USE_ROOTLESS_DOCKERD="\$USE_ROOTLESS_DOCKERD"

dockerd-load-envs() {
if test -z "\$USE_ROOTLESS_DOCKERD"; then
  export DOCKER_HOST="unix:///tmp/\${SERVICE_NAME:-docker}.sock"
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

# Service backend detect
dockerd_detect_systemd () {
  command -v systemctl >/dev/null 2>&1 && test -d /run/systemd/system
}

dockerd_detect_sysv () {
  command -v service >/dev/null 2>&1 && test -d /etc/init.d
}

dockerd_resolve_service_type () {
  local WANT_TYPE=${DOCKER_SERVICE_TYPE:-auto}
  case "$WANT_TYPE" in
  auto)
    if dockerd_detect_systemd; then
      export DOCKER_SERVICE_TYPE_RESOLVED=systemd
    elif dockerd_detect_sysv; then
      export DOCKER_SERVICE_TYPE_RESOLVED=sysv
    else
      echo "error: no available service backend (systemd/sysv)"
      return 1
    fi
    ;;
  systemd)
    dockerd_detect_systemd || (echo "error: DOCKER_SERVICE_TYPE=systemd unavailable"; return 1)
    export DOCKER_SERVICE_TYPE_RESOLVED=systemd
    ;;
  sysv)
    dockerd_detect_sysv || (echo "error: DOCKER_SERVICE_TYPE=sysv unavailable"; return 1)
    export DOCKER_SERVICE_TYPE_RESOLVED=sysv
    ;;
  *)
    echo "error: unsupported DOCKER_SERVICE_TYPE='$WANT_TYPE' (allowed: auto|systemd|sysv)"
    return 1
    ;;
  esac

  if test "$DOCKER_SERVICE_TYPE_RESOLVED" = "sysv"; then
    if ! command -v update-rc.d >/dev/null 2>&1 && ! command -v chkconfig >/dev/null 2>&1; then
      echo "warn: update-rc.d/chkconfig not found, auto-start registration will be skipped"
    fi
  fi

  echo "service backend resolved: $DOCKER_SERVICE_TYPE_RESOLVED"
}

# Systemd Service
dockerd_systemd_service_install () {
local DOCKER_SERVICE_FILE="${DOCKER_SYSTEMD_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}"
if test -f "$DOCKER_SERVICE_FILE" ; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  return 1
fi

local DOCKER_UNIX_SOCK=unix:///tmp/${SERVICE_NAME}.sock
local DOCKERD_TMP_DIR=/tmp/${SERVICE_NAME}
local DOCKER_BIN="$SCRIPT_HOME/bin"
local DOCKERD_ARGS='-H '$DOCKER_UNIX_SOCK' --exec-root '$DOCKERD_TMP_DIR'/run/docker -p '$DOCKERD_TMP_DIR'/run/docker.pid --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/'$SERVICE_NAME

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

dockerd_systemd_service_uninstall () {
  local DOCKER_SERVICE_FILE="${DOCKER_SYSTEMD_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}"
  local UNIT_FILE="${SERVICE_NAME}.service"

  if test ! -f "$DOCKER_SERVICE_FILE"; then
    echo "down: systemd unit '$UNIT_FILE' not found, skip"
    return 0
  fi

  systemctl stop "$SERVICE_NAME"
  systemctl disable "$UNIT_FILE"
  rm -f "$DOCKER_SERVICE_FILE"
  systemctl daemon-reload
}

# SysV Service
dockerd_sysv_service_install () {
  local DOCKER_SERVICE_FILE="${DOCKER_SYSV_SERVICE_FILE:-/etc/init.d/${SERVICE_NAME}}"
  if test -f "$DOCKER_SERVICE_FILE" ; then
    echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
    return 1
  fi

  local DOCKER_UNIX_SOCK=unix:///tmp/${SERVICE_NAME}.sock
  local DOCKERD_TMP_DIR=/tmp/${SERVICE_NAME}
  local DOCKER_BIN="$SCRIPT_HOME/bin"
  local DOCKERD_ARGS='-H '$DOCKER_UNIX_SOCK' --exec-root '$DOCKERD_TMP_DIR'/run/docker -p '$DOCKERD_TMP_DIR'/run/docker.pid --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/'$SERVICE_NAME

  if test ! -f "$SCRIPT_HOME/daemon.json" ; then
cat <<EOF > "$SCRIPT_HOME/daemon.json"
{
}
EOF
  fi

cat <<EOF > "$DOCKER_SERVICE_FILE"
#!/bin/sh
### BEGIN INIT INFO
# Provides:          ${SERVICE_NAME}
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Docker Application Container Engine
### END INIT INFO

NAME="${SERVICE_NAME}"
PID_FILE="${DOCKERD_TMP_DIR}/run/docker.pid"
DOCKERD_BIN="${DOCKER_BIN}/dockerd"
DOCKERD_ARGS="${DOCKERD_ARGS}"
PATH="${DOCKER_BIN}:\$PATH"

start_service() {
  if test -f "\$PID_FILE" && kill -0 \$(cat "\$PID_FILE") 2>/dev/null; then
    echo "\$NAME is already running"
    return 0
  fi
  mkdir -p "${DOCKERD_TMP_DIR}/run"
  nohup "\$DOCKERD_BIN" \$DOCKERD_ARGS >/tmp/\${NAME}.log 2>&1 &
  sleep 1
  if test -f "\$PID_FILE" && kill -0 \$(cat "\$PID_FILE") 2>/dev/null; then
    echo "Started \$NAME"
  else
    echo "Failed to start \$NAME"
    return 1
  fi
}

stop_service() {
  if test ! -f "\$PID_FILE"; then
    echo "\$NAME is not running"
    return 0
  fi
  PID=\$(cat "\$PID_FILE")
  if kill -0 "\$PID" 2>/dev/null; then
    kill "\$PID" || true
    sleep 1
    kill -9 "\$PID" 2>/dev/null || true
  fi
  rm -f "\$PID_FILE"
  echo "Stopped \$NAME"
}

status_service() {
  if test -f "\$PID_FILE" && kill -0 \$(cat "\$PID_FILE") 2>/dev/null; then
    echo "\$NAME is running (pid \$(cat "\$PID_FILE"))"
    return 0
  fi
  echo "\$NAME is not running"
  return 3
}

case "\$1" in
start) start_service ;;
stop) stop_service ;;
restart) stop_service; start_service ;;
status) status_service ;;
*) echo "Usage: \$0 {start|stop|restart|status}"; exit 1 ;;
esac
EOF

  chmod +x "$DOCKER_SERVICE_FILE"
  if command -v update-rc.d >/dev/null 2>&1; then
    update-rc.d "$SERVICE_NAME" defaults
  elif command -v chkconfig >/dev/null 2>&1; then
    chkconfig --add "$SERVICE_NAME"
  fi
  service "$SERVICE_NAME" start
  service "$SERVICE_NAME" status
}

dockerd_sysv_service_uninstall () {
  local DOCKER_SERVICE_FILE="${DOCKER_SYSV_SERVICE_FILE:-/etc/init.d/${SERVICE_NAME}}"

  if test ! -f "$DOCKER_SERVICE_FILE"; then
    echo "down: sysv script '$DOCKER_SERVICE_FILE' not found, skip"
    return 0
  fi

  service "$SERVICE_NAME" stop
  if command -v update-rc.d >/dev/null 2>&1; then
    update-rc.d -f "$SERVICE_NAME" remove
  elif command -v chkconfig >/dev/null 2>&1; then
    chkconfig --del "$SERVICE_NAME"
  fi
  rm -f "$DOCKER_SERVICE_FILE" || return 1
}

dockerd_service_install_by_type () {
  if test "$DOCKER_SERVICE_TYPE_RESOLVED" = "systemd"; then
    dockerd_systemd_service_install
  else
    dockerd_sysv_service_install
  fi
}

dockerd_service_uninstall () {
  local WANT_TYPE=${DOCKER_SERVICE_TYPE:-auto}

  if test "$WANT_TYPE" = "auto" || test "$WANT_TYPE" = "sysv"; then
    if dockerd_detect_sysv; then
      echo "down: try sysv backend"
      dockerd_sysv_service_uninstall || echo "warn: sysv down failed, continue"
    else
      echo "down: sysv backend not available, skip"
    fi
  fi

  if test "$WANT_TYPE" = "auto" || test "$WANT_TYPE" = "systemd"; then
    if dockerd_detect_systemd; then
      echo "down: try systemd backend"
      dockerd_systemd_service_uninstall || echo "warn: systemd down failed, continue"
    else
      echo "down: systemd backend not available, skip"
    fi
  fi
}

dockerd_rootless_service_install () {
  PATH=$PATH:"$SCRIPT_HOME/bin"
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh uninstall
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh install "$@"
}

dockerd_rootless_service_uninstall () {
  PATH=$PATH:"$SCRIPT_HOME/bin"
  "$SCRIPT_HOME"/bin/dockerd-rootless-setuptool.sh uninstall
}

test "$(id -u)" = "0" && export IS_ROOT=1

if test "$#" -lt 1; then
  echo "usage: <install|install-rootless|up|down|envrc|hint>"
  echo "env: DOCKER_SERVICE_TYPE=auto|systemd|sysv (default: auto)"
  exit 1
fi

export ACTION=$1
shift
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
    dockerd_resolve_service_type
    dockerd_install
    dockerd_envrc_install
    dockerd_service_install_by_type
  else
    dockerd_install
    if test -w "$SCRIPT_HOME"; then
      dockerd_envrc_install
    else
      echo "warn: '$SCRIPT_HOME' is not writable, skip updating .envrc"
    fi
    dockerd_rootless_install
    dockerd_rootless_service_install "$@"
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
