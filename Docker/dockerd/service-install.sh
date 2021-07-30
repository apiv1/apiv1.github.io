#!/bin/sh

DOCKER_BIN=${DOCKER_BIN}
DOCKERD_ARGS=${DOCKERD_ARGS}
DOCKER_SERVICE_FILE=${DOCKER_SERVICE_FILE:-/etc/systemd/system/docker.service}

if [ -f "$DOCKER_SERVICE_FILE" ]; then
  echo "'$DOCKER_SERVICE_FILE' already exist. delete or move it manually to continue install."
  exit 1
fi

while [ ! -n "$DOCKER_BIN" ]; do
  echo -n 'Please specific $DOCKER_BIN folder:'
  read DOCKER_BIN
done

echo '
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com

[Service]
Type=notify
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

systemctl daemon-reload
systemctl start docker
systemctl enable docker.service
systemctl status --no-pager -l docker