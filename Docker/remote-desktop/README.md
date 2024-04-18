### Build
```bash
docker build . --target builder -t apiv1/remote-desktop:builder --push
docker build . --build-arg STAGE_BUILDER=apiv1/remote-desktop:builder --target deploy -t apiv1/remote-desktop --push

docker buildx build . --target builder --platform linux/amd64,linux/arm64 --push -t apiv1/remote-desktop:builder
docker buildx build . --build-arg STAGE_BUILDER=apiv1/remote-desktop:builder --target deploy --platform linux/amd64,linux/arm64 --push -t apiv1/remote-desktop
```