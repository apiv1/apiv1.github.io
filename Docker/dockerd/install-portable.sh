#!/bin/sh
export SCRIPT_HOME=$(cd "$(dirname "$0")";pwd)
export DOCKER_BIN=$SCRIPT_HOME/docker
export DOCKERD_ARGS='-H unix://'$SCRIPT_HOME'/run/docker.sock --config-file '$SCRIPT_HOME'/daemon.json --data-root '$SCRIPT_HOME'/lib/docker  --exec-root '$SCRIPT_HOME'/run/docker -p '$SCRIPT_HOME'/run/docker.pid'

test -f $SCRIPT_HOME/daemon.json || echo '{}' > $SCRIPT_HOME/daemon.json
sh service-install.sh

echo '
Put it into your shell rc file:

  export PATH="'$DOCKER_BIN':$PATH"
  export DOCKER_HOST="'unix://$SCRIPT_HOME/run/docker.sock'"

'