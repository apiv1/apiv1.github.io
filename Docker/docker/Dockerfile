ARG DOCKERD_STAGE=dockerd

FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_VERSION=27.3.1
RUN wget -O /docker.tgz https://download.docker.com/${TARGETOS}/static/stable/$(uname -m)/docker-$DOCKER_VERSION.tgz && \
  tar zxvf /docker.tgz && rm /docker.tgz

FROM alpine AS runner
ARG ALPINE_PROXY=${ALPINE_PROXY:-"mirrors.ustc.edu.cn"}
RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_PROXY}/g" /etc/apk/repositories

FROM runner AS dockerd
COPY --from=base /docker/* /usr/local/bin/
RUN apk add --no-cache --update iptables fuse-overlayfs
ENTRYPOINT [ "dockerd" ]

FROM ${DOCKERD_STAGE} AS dockerd-image

FROM runner AS cli
COPY --from=dockerd-image /usr/local/bin/docker /usr/local/bin/docker
ENTRYPOINT [ "docker" ]