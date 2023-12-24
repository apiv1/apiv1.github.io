#!/bin/sh
set -x
[ \$(id -u) -eq 0 ] || exec sudo \$0 \$@

${KILLALL_K3S_SH}

if command -v systemctl; then
    systemctl disable ${SYSTEM_NAME}
    systemctl reset-failed ${SYSTEM_NAME}
    systemctl daemon-reload
fi
if command -v rc-update; then
    rc-update delete ${SYSTEM_NAME} default
fi

rm -f ${FILE_K3S_SERVICE}
rm -f ${FILE_K3S_ENV}

remove_uninstall() {
    rm -f ${UNINSTALL_K3S_SH}
}
trap remove_uninstall EXIT

if (ls ${SYSTEMD_DIR}/k3s*.service || ls /etc/init.d/k3s*) >/dev/null 2>&1; then
    set +x; echo 'Additional k3s services installed, skipping uninstall of k3s'; set -x
    exit
fi

for cmd in kubectl crictl ctr; do
    if [ -L ${BIN_DIR}/\$cmd ]; then
        rm -f ${BIN_DIR}/\$cmd
    fi
done

rm -rf /etc/rancher/k3s
rm -rf /run/k3s
rm -rf /run/flannel
rm -rf /var/lib/rancher/k3s
rm -rf /var/lib/kubelet
rm -f ${BIN_DIR}/k3s
rm -f ${KILLALL_K3S_SH}

if type yum >/dev/null 2>&1; then
    yum remove -y k3s-selinux
    rm -f /etc/yum.repos.d/rancher-k3s-common*.repo
elif type rpm-ostree >/dev/null 2>&1; then
    rpm-ostree uninstall k3s-selinux
    rm -f /etc/yum.repos.d/rancher-k3s-common*.repo
elif type zypper >/dev/null 2>&1; then
    uninstall_cmd="zypper remove -y k3s-selinux"
    if [ "\${TRANSACTIONAL_UPDATE=false}" != "true" ] && [ -x /usr/sbin/transactional-update ]; then
        uninstall_cmd="transactional-update --no-selfupdate -d run \$uninstall_cmd"
    fi
    \$uninstall_cmd
    rm -f /etc/zypp/repos.d/rancher-k3s-common*.repo
fi