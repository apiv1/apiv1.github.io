#!/bin/bash

source .env

sudo docker run --name gitlab_clone --restart always -d \
-e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/$GITLAB_HOST:/mirrors -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
--entrypoint sh $GITLAB_CLONE_IMAGE -c 'while true; do gitlab-clone /mirrors; TZ=Asia/Shanghai date; sleep 15m; done'