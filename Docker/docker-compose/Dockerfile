ARG DOCKER_COMPOSE_STAGE=docker-compose

FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_COMPOSE_VERSION
RUN wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$TARGETOS-$(uname -m) && \
    chmod +x /usr/local/bin/docker-compose

FROM alpine AS docker-compose
COPY --from=base /usr/local/bin/docker-compose /usr/local/bin/docker-compose
ENTRYPOINT [ "docker-compose" ]

FROM ${DOCKER_COMPOSE_STAGE} AS docker-compose-pack
COPY *compose*.yml /