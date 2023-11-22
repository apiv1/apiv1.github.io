#!/bin/sh

export SSH_HOST=$1
export SSH_PORT=${2:-22}
export SSH_USER=${SSH_USER:-root}

if [ -z "${SSH_HOST}" ]; then
  echo "Usage: $0 <host> [port]"
  exit 1
fi

ssh -p $SSH_PORT ${SSH_USER}@${SSH_HOST} cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/${SSH_HOST}/g"