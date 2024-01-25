ARG DOCKER_COMPOSE_STAGE=docker-compose

FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_COMPOSE_VERSION=v2.24.0
RUN wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$TARGETOS-$(uname -m) && \
    chmod +x /usr/local/bin/docker-compose

FROM scratch AS docker-compose
COPY --from=base /usr/local/bin/docker-compose /docker-compose
ENV PATH /
ENTRYPOINT [ "docker-compose" ]

FROM ${DOCKER_COMPOSE_STAGE} AS docker-compose-pack
COPY *compose*.yml /