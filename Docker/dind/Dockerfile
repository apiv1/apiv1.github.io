FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG DOCKER_VERSION=25.0.0
RUN wget -O /docker.tgz https://download.docker.com/${TARGETOS}/static/stable/$(uname -m)/docker-$DOCKER_VERSION.tgz && \
  tar zxvf /docker.tgz && rm /docker.tgz

FROM scratch
COPY --from=base /docker/docker /docker
ENTRYPOINT [ "/docker" ]