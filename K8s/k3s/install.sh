#!/bin/sh

set -e

if test "server" = "$K3S_MODE" -o "agent" = "$K3S_MODE" -a '' != "$K3S_URL" -a '' != "$K3S_TOKEN" ; then
  echo 'mode' $K3S_MODE
else
  echo 'Usage:'
  echo '  K3S_MODE=server sh install.sh'
  echo '  K3S_MODE=agent K3S_TOKEN=xxxxx K3S_URL=xxxxx sh install.sh'
  exit 1
fi

SERVICE_ARGS=${SERVICE_ARGS:-''}
SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
K3S_BIN="$SCRIPT_HOME/bin"

SYSTEMD_TYPE=exec

if test "server" = "$K3S_MODE" ; then
  SERVICE_NAME=k3s
  CONFIG_FILE="$SCRIPT_HOME/config.yaml"
  K3S_ARGS='server --config '$CONFIG_FILE' --data-dir '$SCRIPT_HOME'/lib/k3s --private-registry '$SCRIPT_HOME'/registries.yaml --default-local-storage-path '$SCRIPT_HOME'/storage --log '$SCRIPT_HOME'/log/output.log --alsologtostderr '$SCRIPT_HOME'/log/err.log '$SERVICE_ARGS
else
  SERVICE_NAME=k3s-agent
  CONFIG_FILE="$SCRIPT_HOME/agent-config.yaml"
  K3S_ARGS='agent --server '$K3S_URL' --token '$K3S_TOKEN' --config '$CONFIG_FILE' --data-dir '$SCRIPT_HOME'/lib/k3s-agent --private-registry '$SCRIPT_HOME'/registries.yaml --log '$SCRIPT_HOME'/log-agent/output.log --alsologtostderr '$SCRIPT_HOME'/log-agent/err.log '$SERVICE_ARGS
fi

K3S_SERVICE_FILE=${K3S_SERVICE_FILE:-/etc/systemd/system/${SERVICE_NAME}.service}

echo '
systemctl stop '$SERVICE_NAME'
systemctl disable '$SERVICE_NAME'.service
rm '$K3S_SERVICE_FILE'
' > $SCRIPT_HOME/uninstall.sh
chmod +x $SCRIPT_HOME/uninstall.sh

if test -f "$K3S_SERVICE_FILE" ; then
  echo "'$K3S_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

if test ! -f "$K3S_BIN/k3s" ; then
    mkdir -p "$K3S_BIN"
    if test -z ${K3S_DOWNLOAD_URL}; then
      K3S_DOWNLOAD_VERSION=$(wget -SqO /dev/null https://update.k3s.io/v1-release/channels/stable 2>&1 | grep -i Location | sed -e 's|.*/||')
      K3S_FILE=k3s
      K3S_ARCH=${K3S_ARCH:-$(arch)}
      case "$K3S_ARCH" in
        arm64)
            K3S_FILE=${K3S_FILE}-${K3S_ARCH}
            ;;
        armhf)
            K3S_FILE=${K3S_FILE}-${K3S_ARCH}
            ;;
        *)
            ;;
      esac
      K3S_DOWNLOAD_URL=https://github.com/k3s-io/k3s/releases/download/${K3S_DOWNLOAD_VERSION}/${K3S_FILE}
    fi
    wget -O "$K3S_BIN/k3s" ${K3S_DOWNLOAD_URL}
fi
chmod +x "$K3S_BIN/k3s"

if test ! -f "$CONFIG_FILE" ; then
  touch "$CONFIG_FILE"
fi

if test ! -f "$SCRIPT_HOME/registries.yaml" ; then
  touch "$SCRIPT_HOME/registries.yaml"
fi

echo '
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
Wants=network-online.target
After=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
Type='$SYSTEMD_TYPE'
EnvironmentFile=-/etc/default/%N
EnvironmentFile=-/etc/sysconfig/%N
KillMode=process
Delegate=yes
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s
Environment="PATH='$K3S_BIN':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStartPre=/bin/sh -xc '"'! /usr/bin/systemctl is-enabled --quiet nm-cloud-setup.service'"'
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart='${K3S_BIN}'/k3s '${K3S_ARGS}'
' > $K3S_SERVICE_FILE

chmod +x $K3S_SERVICE_FILE

if test ! -f "$SCRIPT_HOME/.env" ; then
  if test -z "$DISABLE_K3S_ALIAS" ; then
EXTRA_ALIAS="
alias kubectl='k3s kubectl'
alias ctr='k3s ctr'
alias crictl='k3s crictl'
"
  fi

cat <<EOF > "$SCRIPT_HOME/.env"
K3S_HOME=$(cd "$(dirname "$0" 2>/dev/null)";pwd)
alias k3s='k3s --data-dir \${K3S_HOME}/lib/k3s'
${EXTRA_ALIAS}
export PATH="\$K3S_HOME/bin:\$PATH"
EOF
fi

echo '
Put it into your shell rc file:
    . '$SCRIPT_HOME'/.env
'

systemctl daemon-reload
systemctl start ${SERVICE_NAME}
systemctl enable ${SERVICE_NAME}.service
systemctl status --no-pager -l ${SERVICE_NAME}