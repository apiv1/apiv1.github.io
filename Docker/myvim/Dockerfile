FROM ubuntu:24.04
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/cache/apt/archives,id=apt_${TARGETOS}_${TARGETARCH} \
  sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  apt-get install --update -y \
    busybox \
    git \
    tig \
    git-lfs \
    git-extras \
    vim \
    tree \
    tmux \
  && rm -rf /var/lib/apt/lists/* \
  && \
  busybox --install /usr/local/bin

COPY --from=apiv1/aes /aes /usr/local/sbin/aes