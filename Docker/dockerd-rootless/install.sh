#!/bin/sh

set -e

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)

alias wget='wget --no-check-certificate --timeout=3 --tries=10'

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

if test ! -f "$SCRIPT_HOME/bin/dockerd" ; then
  DOCKER_FILE_NAME=docker.tgz
  DOWNLOAD_DOCKER_SITE=${DOWNLOAD_DOCKER_SITE:-https://download.docker.com}
  if test ! -f $DOCKER_FILE_NAME; then
    if test -z $DOCKER_DOWNLOAD_URL; then
      if test -z $DOCKER_VERSION; then
        echo query DOCKER_VERSION ...
        DOCKER_VERSION=$(wget -qO - ${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ARCH}/ | grep -e 'docker-[0-9]' | sed 's/^.*docker-//g' | sed 's/\.tgz.*$//g' | tail -1)
        test -z $DOCKER_VERSION && ( echo error: DOCKER_VERSION query failed ; exit 1 )
      fi
      DOCKER_DOWNLOAD_URL=${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz
    fi
    wget -O ${DOCKER_FILE_NAME} "${DOCKER_DOWNLOAD_URL}"
  fi
  tar zxvf ${DOCKER_FILE_NAME} && rm -rf ${DOCKER_FILE_NAME}

  mkdir -p bin
  mv docker/* bin/
  rmdir docker
fi

DOCKER_ROOTLESS_ARCH=$DOCKER_ARCH
DOCKER_ROOTLESS_VERSION=$DOCKER_VERSION

if test ! -f "$SCRIPT_HOME/bin/dockerd-rootless.sh" ; then
  DOCKER_ROOTLESS_FILE_NAME=docker-rootless-extras.tgz
  DOWNLOAD_DOCKER_SITE=${DOWNLOAD_DOCKER_SITE:-https://download.docker.com}
  if test ! -f $DOCKER_ROOTLESS_FILE_NAME; then
    if test -z $DOCKER_ROOTLESS_DOWNLOAD_URL; then
      if test -z $DOCKER_ROOTLESS_VERSION; then
        echo query DOCKER_ROOTLESS_VERSION ...
        DOCKER_ROOTLESS_VERSION=$(wget -qO - ${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ROOTLESS_ARCH}/ | grep -e 'docker-rootless-extras-[0-9]' | sed 's/^.*docker-rootless-extras-//g' | sed 's/\.tgz.*$//g' | tail -1)
        test -z $DOCKER_ROOTLESS_VERSION && ( echo error: DOCKER_ROOTLESS_VERSION query failed ; exit 1 )
      fi
      DOCKER_ROOTLESS_DOWNLOAD_URL=${DOWNLOAD_DOCKER_SITE}/linux/static/stable/${DOCKER_ROOTLESS_ARCH}/docker-rootless-extras-${DOCKER_ROOTLESS_VERSION}.tgz
    fi
    wget -O ${DOCKER_ROOTLESS_FILE_NAME} "${DOCKER_ROOTLESS_DOWNLOAD_URL}"
  fi
  tar zxvf ${DOCKER_ROOTLESS_FILE_NAME} && rm -rf ${DOCKER_ROOTLESS_FILE_NAME}

  mkdir -p bin
  mv docker-rootless-extras/* bin/
  rmdir docker-rootless-extras
fi

PATH=$PATH:"$SCRIPT_HOME/bin"
bin/dockerd-rootless-setuptool.sh uninstall || :
bin/dockerd-rootless-setuptool.sh install

DOCKER_UNIX_SOCK="unix://${XDG_RUNTIME_DIR}/docker.sock"

cat <<EOF > "$SCRIPT_HOME/.envrc"
DOCKER_HOME="$SCRIPT_HOME"
export PATH="\$DOCKER_HOME/bin:\$PATH"
export DOCKER_HOST="$DOCKER_UNIX_SOCK"
test -n "\$DOCKER_HOST" -a -z "\$DOCKER_SOCK" && export DOCKER_SOCK=\${DOCKER_HOST//unix:\/\//}
load_docker_envs() {
  local ENV_PATH="\$DOCKER_HOME/.envrc.d"
  for item in \$(ls -A \${ENV_PATH} 2>/dev/null)
  do
    . "\$ENV_PATH/\$item"
  done
}
load_docker_envs
EOF

echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.envrc
'