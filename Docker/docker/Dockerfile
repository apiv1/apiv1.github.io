ARG DOCKER_FULL_STAGE=full

FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_VERSION=26.0.0
RUN wget -O /docker.tgz https://download.docker.com/${TARGETOS}/static/stable/$(uname -m)/docker-$DOCKER_VERSION.tgz && \
  tar zxvf /docker.tgz && rm /docker.tgz

FROM alpine AS runner
ARG ALPINE_PROXY=${ALPINE_PROXY:-"mirrors.ustc.edu.cn"}
RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_PROXY}/g" /etc/apk/repositories

FROM runner AS full
RUN apk add --no-cache --update iptables
COPY --from=base /docker/* /usr/local/bin/
ENTRYPOINT [ "dockerd" ]

FROM ${DOCKER_FULL_STAGE} AS full-image

FROM runner AS cli
COPY --from=full-image /usr/local/bin/docker /usr/local/bin/docker
ENTRYPOINT [ "docker" ]