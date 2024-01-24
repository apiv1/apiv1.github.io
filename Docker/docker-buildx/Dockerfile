FROM scratch
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_BUILDX_VERSION=v0.12.0
ADD --chmod=755 https://github.com/docker/buildx/releases/download/$DOCKER_BUILDX_VERSION/buildx-$DOCKER_BUILDX_VERSION.$TARGETOS-$TARGETARCH /docker-buildx
ENTRYPOINT [ "/docker-buildx" ]