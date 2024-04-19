FROM apiv1/remote-desktop
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/lib/apt/lists,id=apt_${TARGETOS}_${TARGETARCH} \
  apt-get install --update -y \
  iptables fuse-overlayfs \
  busybox \
  curl \
  wget \
  git \
  tig \
  git-lfs \
  git-extras \
  vim \
  tree \
  openssh-server \
  openssl \
  tmux \
  ;
COPY --from=apiv1/dockerd /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/code-server /code-server /code-server
COPY --from=apiv1/aes /aes /usr/local/sbin/aes
COPY init.d /init.d
COPY init.sh /init.sh
RUN rm /usr/local/bin/entrypoint.sh && \
    ln -s /code-server/bin/code-server /bin/code-server && \
    chmod +x /init.d/*.sh /init.sh
ENTRYPOINT ["/init.sh"]