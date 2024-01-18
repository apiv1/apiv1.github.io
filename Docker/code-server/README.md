build

```bash
# apiv1/code-server
docker build . --target code-server -t apiv1/code-server
docker buildx build . --target code-server --platform linux/amd64,linux/arm64 --push -t apiv1/code-server

# apiv1/code-server:daemon
docker build . --target daemon --build-arg STAGE_PREFIX=apiv1/ -t apiv1/code-server:daemon
docker buildx build . --target daemon --build-arg STAGE_PREFIX=apiv1/ --platform linux/amd64,linux/arm64 --push -t apiv1/code-server:daemon
```

hashed password

```shell
# in zsh (echo -n without '\n')
echo -n "thisismypassword" | npx argon2-cli -e

# in docker(recommend)
docker run --rm -it leplusorg/hash sh -c 'echo -n thisismypassword | argon2 thisissalt -e'
```
