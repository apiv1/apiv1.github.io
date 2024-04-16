### Build
```bash
docker build . --target deploy -t apiv1/remote-desktop --push
docker buildx build . --target deploy --platform linux/amd64,linux/arm64 --push -t apiv1/remote-desktop
```