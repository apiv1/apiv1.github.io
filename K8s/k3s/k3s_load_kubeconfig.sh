#!/bin/sh

export SSH_HOST=$1
export SSH_PORT=$2
export SSH_USER=${SSH_USER:-root}

if [ -z "${SSH_HOST}" ]; then
  echo "Usage: $0 <host> [port]"
  echo "env: SSH_ARGS SSH_KEY SSH_USER"
  exit 1
fi

SSH_ARGS="$SSH_ARGS"
if [ -n "${SSH_PORT}" ]; then
  SSH_ARGS="$SSH_ARGS -p $SSH_PORT"
fi
if [ -n "${SSH_KEY}" ]; then
  SSH_ARGS="$SSH_ARGS -i $SSH_KEY"
fi

ssh $SSH_ARGS ${SSH_USER}@${SSH_HOST} cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/${SSH_HOST}/g"