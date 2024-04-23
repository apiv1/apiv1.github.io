ARG STAGE_REMOTE_DESKTOP=apiv1/remote-desktop
FROM ${STAGE_REMOTE_DESKTOP} AS deploy
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/cache/apt/archives,id=apt_${TARGETOS}_${TARGETARCH} \
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
  x11vnc \
  skopeo \
  fonts-droid-fallback \
  remmina remmina-plugin-rdp remmina-plugin-secret \
  && rm -rf /var/lib/apt/lists/*
COPY --from=apiv1/dockerd /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/code-server /code-server /code-server
COPY --from=apiv1/aes /aes /usr/local/sbin/aes
COPY init.d /init.d
COPY init.sh /init.sh
RUN rm /usr/local/bin/entrypoint.sh && \
    ln -s /code-server/bin/code-server /bin/code-server && \
    chmod +x /init.d/*.sh /init.sh
ENTRYPOINT ["/init.sh"]