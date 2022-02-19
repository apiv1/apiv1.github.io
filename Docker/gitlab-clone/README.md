run
```bash
export GITLAB_CLONE_IMAGE=<image-name>
export CI_API_V4_URL=https://<gitlab-url>/api/v4
export GITLAB_API_PRIVATE_TOKEN=<token>

# clone for once
docker run --rm -it \
-e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/mirrors:/mirrors -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
$GITLAB_CLONE_IMAGE /mirrors

# clone every day
docker run --name gitlab_clone --restart always -d \
-e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/mirrors:/mirrors -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
--entrypoint sh $GITLAB_CLONE_IMAGE -c 'while true; do gitlab-clone /mirrors; sleep 1d; done'
```