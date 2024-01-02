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

KILLALL_K3S_SH=${KILLALL_K3S_SH:-${SCRIPT_HOME}/killall.sh}
UNINSTALL_K3S_SH=${UNINSTALL_K3S_SH:-${SCRIPT_HOME}/uninstall.sh}

test $(id -u) -eq 0 || export SUDO=sudo

# --- create killall script ---
create_killall() {
    test "${INSTALL_K3S_BIN_DIR_READ_ONLY}" = true && return
    $SUDO tee ${KILLALL_K3S_SH} >/dev/null << \EOF
#!/bin/sh
test $(id -u) -eq 0 || exec sudo $0 $@

set -x

pschildren() {
    ps -e -o ppid= -o pid= | \
    sed -e 's/^\s*//g; s/\s\s*/\t/g;' | \
    grep -w "^$1" | \
    cut -f2
}

pstree() {
    for pid in $@; do
        echo $pid
        for child in $(pschildren $pid); do
            pstree $child
        done
    done
}

killtree() {
    kill -9 $(
        { set +x; } 2>/dev/null;
        pstree $@;
        set -x;
    ) 2>/dev/null
}

remove_interfaces() {
    # Delete network interface(s) that match 'master cni0'
    ip link show 2>/dev/null | grep 'master cni0' | while read ignore iface ignore; do
        iface=${iface%%@*}
        test -z "$iface" || ip link delete $iface
    done

    # Delete cni related interfaces
    ip link delete cni0
    ip link delete flannel.1
    ip link delete flannel-v6.1
    ip link delete kube-ipvs0
    ip link delete flannel-wg
    ip link delete flannel-wg-v6

    # Restart tailscale
    if test -n "$(command -v tailscale)"; then
        tailscale set --advertise-routes=
    fi
}

getshims() {
    ps -e -o pid= -o args= | sed -e 's/^ *//; s/\s\s*/\t/;' | grep -w 'k3s/data/[^/]*/bin/containerd-shim' | cut -f1
}

killtree $({ set +x; } 2>/dev/null; getshims; set -x)

do_unmount_and_remove() {
    set +x
    while read -r _ path _; do
        case "$path" in $1*) echo "$path" ;; esac
    done < /proc/self/mounts | sort -r | xargs -r -t -n 1 sh -c 'umount -f "$0" && rm -rf "$0"'
    set -x
}

do_unmount_and_remove '/run/k3s'
do_unmount_and_remove '/var/lib/rancher/k3s'
do_unmount_and_remove '/var/lib/kubelet/pods'
do_unmount_and_remove '/var/lib/kubelet/plugins'
do_unmount_and_remove '/run/netns/cni-'

# Remove CNI namespaces
ip netns show 2>/dev/null | grep cni- | xargs -r -t -n 1 ip netns delete

remove_interfaces

rm -rf /var/lib/cni/
iptables-save | grep -v KUBE- | grep -v CNI- | grep -iv flannel | iptables-restore
ip6tables-save | grep -v KUBE- | grep -v CNI- | grep -iv flannel | ip6tables-restore
EOF
    $SUDO chmod 755 ${KILLALL_K3S_SH}
    $SUDO chown root:root ${KILLALL_K3S_SH}
}

# --- create uninstall script ---
create_uninstall() {
    test "${INSTALL_K3S_BIN_DIR_READ_ONLY}" = true && return
    $SUDO tee ${UNINSTALL_K3S_SH} >/dev/null << EOF
#!/bin/sh
set -x
test $(id -u) -eq 0 || exec sudo $0 $@

${KILLALL_K3S_SH}

if command -v systemctl; then
    systemctl disable ${SERVICE_NAME} --now
    systemctl reset-failed ${SERVICE_NAME}
    systemctl daemon-reload
fi

rm -f ${K3S_SERVICE_FILE}
rm -f ${K3S_ENV_FILE}

remove_uninstall() {
    rm -f ${UNINSTALL_K3S_SH}
}
trap remove_uninstall EXIT

if (ls ${SYSTEMD_DIR}/k3s*.service || ls /etc/init.d/k3s*) >/dev/null 2>&1; then
    set +x; echo 'Additional k3s services installed, skipping uninstall of k3s'; set -x
    exit
fi

rm -rf /etc/rancher/k3s
rm -rf /run/k3s
rm -rf /run/flannel
rm -rf /var/lib/rancher/k3s
rm -rf /var/lib/kubelet
rm -f ${KILLALL_K3S_SH}
EOF
    $SUDO chmod 755 ${UNINSTALL_K3S_SH}
    $SUDO chown root:root ${UNINSTALL_K3S_SH}
}

create_killall
create_uninstall

if test -f "$K3S_SERVICE_FILE" ; then
  echo "'$K3S_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

if test ! -f "$K3S_BIN/k3s" ; then
    mkdir -p "$K3S_BIN"
    if test -z ${K3S_DOWNLOAD_URL}; then
      K3S_DOWNLOAD_VERSION=$(wget -SqO /dev/null https://update.k3s.io/v1-release/channels/stable 2>&1 | grep -i Location | sed -e 's|.*/||')
      K3S_FILE=k3s
      K3S_ARCH=${K3S_ARCH:-$(uname -m)}
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
ExecStop='${KILLALL_K3S_SH}'
' > $K3S_SERVICE_FILE

chmod +x $K3S_SERVICE_FILE

K3S_ENV_FILE=$SCRIPT_HOME/.env
if test ! -f "$K3S_ENV_FILE" ; then
  if test -z "$DISABLE_K3S_ALIAS" ; then
EXTRA_ALIAS="
alias kubectl='k3s kubectl'
alias ctr='k3s ctr'
alias crictl='k3s crictl'
"
  fi

cat <<EOF > "$K3S_ENV_FILE"
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