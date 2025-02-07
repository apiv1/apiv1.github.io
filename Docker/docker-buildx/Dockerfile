FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_BUILDX_VERSION
RUN wget -O /usr/local/bin/docker-buildx https://github.com/docker/buildx/releases/download/$DOCKER_BUILDX_VERSION/buildx-$DOCKER_BUILDX_VERSION.$TARGETOS-$TARGETARCH && \
  chmod +x /usr/local/bin/docker-buildx

FROM alpine AS docker-buildx
ARG ALPINE_PROXY=${ALPINE_PROXY:-"mirrors.ustc.edu.cn"}
RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_PROXY}/g" /etc/apk/repositories && \
    apk add --no-cache --update git

COPY --from=base /usr/local/bin/docker-buildx /usr/local/bin/docker-buildx
ENTRYPOINT [ "docker-buildx" ]