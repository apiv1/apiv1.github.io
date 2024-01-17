FROM ubuntu AS base

FROM base AS base_private
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated && \
  apt install -y \
    git \
    git-lfs \
    git-extras \
    vim \
    tree