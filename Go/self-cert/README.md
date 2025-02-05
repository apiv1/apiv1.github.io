# Self cert

### build
```bash
docker build . --build-arg APP_NAME=self-cert -t apiv1/self-cert

docker buildx build . --build-arg APP_NAME=self-cert --platform linux/amd64,linux/arm64 --pull --push -t apiv1/self-cert # extend platform
```