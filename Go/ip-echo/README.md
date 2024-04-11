### build
```bash
docker build . --build-arg APP_NAME=ip-echo -t apiv1/ip-echo
docker buildx build . --build-arg APP_NAME=ip-echo --platform linux/amd64,linux/arm64 --push -t apiv1/ip-echo # buildkit
```

### run
```bash
docker run --rm -p 8089:8089 apiv1/ip-echo
docker run --rm --network host apiv1/ip-echo
```