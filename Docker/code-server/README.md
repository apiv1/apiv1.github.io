build

```bash
export CODE_SERVER_VERSION=4.20.0
# apiv1/code-server
docker build . --target code-server --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION  -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION
docker buildx build . --target code-server --platform linux/amd64,linux/arm64 --build-arg CODE_SERVER_VERSION=$CODE_SERVER_VERSION --push -t apiv1/code-server -t apiv1/code-server:$CODE_SERVER_VERSION

# apiv1/code-server:daemon
docker build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION
docker buildx build . --target daemon --build-arg CODE_SERVER_IMAGE=apiv1/code-server:$CODE_SERVER_VERSION --platform linux/amd64,linux/arm64 --push -t apiv1/code-server:daemon -t apiv1/code-server:daemon-$CODE_SERVER_VERSION
```

hashed password

```shell
# in zsh (echo -n without '\n')
echo -n "thisismypassword" | npx argon2-cli -e

# in docker(recommend)
docker run --rm -it leplusorg/hash sh -c 'echo -n thisismypassword | argon2 thisissalt -e'
```
