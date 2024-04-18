ARG CODE_SERVER_IMAGE=code-server

FROM netdata/wget AS code-server
ARG TARGETOS
ARG TARGETARCH
ARG CODE_SERVER_VERSION=4.23.0
RUN wget -O /tmp/code-server.tar.gz https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz && \
  mkdir /code-server && tar xvf /tmp/code-server.tar.gz -C /code-server --strip-components=1 && rm /tmp/code-server.tar.gz

FROM ${CODE_SERVER_IMAGE} AS stage-code-server

FROM ubuntu:24.04 AS daemon
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/lib/apt/lists,id=apt_${TARGETOS}_${TARGETARCH} \
  sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  apt-get install --update -y \
    busybox \
    curl \
    wget \
    git \
    tig \
    git-lfs \
    git-extras \
    vim \
    tree \
    tmux \
    && \
  busybox --install /usr/local/bin
COPY --from=apiv1/aes /aes /usr/local/sbin/aes

COPY --from=stage-code-server /code-server /code-server
COPY entrypoint.sh /entrypoint.sh
RUN ln -s /code-server/bin/code-server /bin/code-server && \
  chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]