ARG STAGE_REMOTE_DESKTOP=apiv1/remote-desktop
ARG STAGE_CORE=core
FROM ${STAGE_REMOTE_DESKTOP} AS core
ARG TARGETOS
ARG TARGETARCH
RUN apt-get install --update -y \
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
  && rm -rf /var/lib/apt/lists/* \
  && rm /usr/local/bin/entrypoint.sh
COPY --from=apiv1/aes /aes /usr/local/sbin/aes
COPY --chmod=0755 init.d/xrdp*.sh init.d/sshd*.sh /init.d/
COPY --chmod=0755 init.sh /init.sh
ENTRYPOINT ["/init.sh"]

FROM ${STAGE_CORE} as full
# dockerd service
COPY --from=apiv1/dockerd /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/docker-compose /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/docker-buildx /usr/local/bin/* /usr/local/bin/
COPY --chmod=0755 init.d/dockerd.service.sh /init.d/
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
  ln -s $(which docker-compose) /usr/local/lib/docker/cli-plugins/ && \
  ln -s $(which docker-buildx) /usr/local/lib/docker/cli-plugins/

# code-server service
COPY --from=apiv1/code-server /code-server /code-server
COPY --chmod=0755 init.d/code-server*.sh /init.d/
RUN ln -s /code-server/bin/code-server /bin/code-server