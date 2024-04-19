### Build
```bash
docker build . -t apiv1/richenv --pull --push
docker buildx build . --platform linux/amd64,linux/arm64 --pull --push -t apiv1/richenv

# chrome (only amd64)
docker buildx build . --build-arg STAGE_REMOTE_DESKTOP=apiv1/remote-desktop:chrome --platform linux/amd64 --pull --push -t apiv1/richenv:chrome
```