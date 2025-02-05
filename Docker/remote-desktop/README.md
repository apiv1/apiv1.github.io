### Build

```bash
# build
docker build . --target builder -t apiv1/remote-desktop:builder --push
docker buildx build . --target builder --platform linux/amd64,linux/arm64 --pull --push -t apiv1/remote-desktop:builder

# deploy
docker build . --build-arg STAGE_BUILDER=apiv1/remote-desktop:builder --target deploy -t apiv1/remote-desktop --pull --push
docker buildx build . --build-arg STAGE_BUILDER=apiv1/remote-desktop:builder --target deploy --platform linux/amd64,linux/arm64 --pull --push -t apiv1/remote-desktop

# chrome (amd64 only)
docker build . --build-arg STAGE_DEPLOY=apiv1/remote-desktop --target chrome -t apiv1/remote-desktop:chrome --push
docker buildx build . --build-arg STAGE_DEPLOY=apiv1/remote-desktop --target chrome --platform linux/amd64 --pull --push -t apiv1/remote-desktop:chrome
```