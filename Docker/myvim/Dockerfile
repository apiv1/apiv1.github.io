FROM ubuntu AS base

FROM base AS base_private
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated && \
  apt install -y \
    git \
    tig \
    git-lfs \
    git-extras \
    vim \
    tree

COPY --from=apiv1/aes /usr/local/bin/aes /usr/local/bin/aes