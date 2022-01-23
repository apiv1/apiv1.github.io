#!/bin/sh

export HOST=$1
export PORT=${2:-22}
export SSH_USER=${SSH_USER:-root}

if [ -z "${HOST}" ]; then
  echo "Usage: $0 <host>:[port]"
  exit 1
fi

echo 'download KUBECONFIG file...'
CERT_FILE=${HOST}.cert.yaml
scp -P $PORT ${SSH_USER}@${HOST}:/etc/rancher/k3s/k3s.yaml ${CERT_FILE}
sed -i "s/127.0.0.1/${HOST}/g" ${CERT_FILE}
echo "downloaded KUBECONFIG file: '${CERT_FILE}'"