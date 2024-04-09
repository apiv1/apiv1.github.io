ARG DOCKER_FULL_STAGE=full

FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_VERSION=26.0.0
RUN wget -O /docker.tgz https://download.docker.com/${TARGETOS}/static/stable/$(uname -m)/docker-$DOCKER_VERSION.tgz && \
  tar zxvf /docker.tgz && rm /docker.tgz

FROM scratch AS full
COPY --from=base /docker /docker
ENV PATH /docker
ENTRYPOINT [ "docker" ]

FROM ${DOCKER_FULL_STAGE} AS full-image

FROM scratch AS cli
COPY --from=full-image /docker/docker /docker
ENV PATH /
ENTRYPOINT [ "docker" ]