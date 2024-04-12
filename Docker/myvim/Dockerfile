FROM ubuntu:24.04 AS base

FROM base AS base_private
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated && \
  apt install -y \
    busybox \
    git \
    tig \
    git-lfs \
    git-extras \
    vim \
    tree && apt clean && \
  busybox --install /usr/local/bin

COPY --from=apiv1/aes /aes /usr/local/sbin/aes