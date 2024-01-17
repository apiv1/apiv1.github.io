```bash
docker build . -t apiv1/myvim
docker buildx build . --platform linux/amd64,linux/arm64 --push -t apiv1/myvim
```