### build
```bash
docker build . --build-arg APP_NAME=aes -t apiv1/aes
docker buildx build . --build-arg APP_NAME=aes --platform linux/amd64,linux/arm64 --push -t apiv1/aes # buildkit
```