ARG CODE_SERVER_IMAGE=code-server
ARG DIND_IMAGE=apiv1/dind:25.0.0
ARG DOCKER_COMPOSE_IMAGE=apiv1/docker-compose:v2.24.0

FROM ubuntu:24.04 AS code-server
ARG TARGETOS
ARG TARGETARCH
ARG CODE_SERVER_VERSION=4.20.0
ADD https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/code-server.tar.gz
RUN mkdir /code-server && tar xvf /tmp/code-server.tar.gz -C /code-server --strip-components=1 && rm /tmp/code-server.tar.gz

FROM ${CODE_SERVER_IMAGE} AS stage-code-server

FROM stage-code-server AS daemon
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated && \
  apt install -y \
    busybox \
    tini \
    curl \
    wget \
    git \
    tig \
    git-lfs \
    git-extras \
    vim \
    tree && \
  busybox --install /usr/local/bin
COPY --from=apiv1/aes /aes /usr/local/sbin/aes

COPY entrypoint.sh /entrypoint.sh
RUN ln -s /code-server/bin/code-server /bin/code-server && \
  chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]