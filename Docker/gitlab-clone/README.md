build
```bash
docker buildx build . --platform linux/amd64,linux/arm64 --target runner --push -t apiv1/gitlab # gitlab-runner
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/gitlab:clone # gitlab-clone
```

[compose.yml](./compose.yml)
```shell
# if use http
cp ~/.git-credentials .git-credentials

# if use ssh
cp ~/.ssh/id_rsa id_rsa

cp env.example .env
vim .env # set env here

docker-compose up
```

run
```bash
export GITLAB_CLONE_IMAGE=apiv1/gitlab:clone
export GITLAB_HOST=<gitlab-host>
export GITLAB_API_PRIVATE_TOKEN=<token>
export CI_API_V4_URL=https://$GITLAB_HOST/api/v4

# clone for once
docker run --rm -it \
-e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/$GITLAB_HOST:/mirrors -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
$GITLAB_CLONE_IMAGE /mirrors

# clone for once (http auth)
docker run --rm -it \
-e USE_HTTP_REPO=1 -e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/$GITLAB_HOST:/mirrors -v $PWD/.git-credentials:/root/.git-credentials \
$GITLAB_CLONE_IMAGE /mirrors

# clone per 15min
docker run --name gitlab_clone --restart always -d \
-e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/$GITLAB_HOST:/mirrors -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
--entrypoint sh $GITLAB_CLONE_IMAGE -c 'while true; do gitlab-clone /mirrors; TZ=Asia/Shanghai date; sleep 15m; done'

# clone per 15min (http auth)
docker run --name gitlab_clone --restart always -d \
-e USE_HTTP_REPO=1 -e IGNORE_ARCHIVED_PROJECT=1 -e CI_API_V4_URL=$CI_API_V4_URL -e GITLAB_API_PRIVATE_TOKEN=$GITLAB_API_PRIVATE_TOKEN \
-v $PWD/$GITLAB_HOST:/mirrors -v $PWD/.git-credentials:/root/.git-credentials \
--entrypoint sh $GITLAB_CLONE_IMAGE -c 'while true; do gitlab-clone /mirrors; TZ=Asia/Shanghai date; sleep 15m; done'
```

refs
====
gems:
[Git](https://rubydoc.info/gems/git)
[Gitlab](https://rubydoc.info/gems/gitlab)
