FROM apiv1/remote-desktop
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
  openssl
COPY --from=apiv1/dockerd /usr/local/bin/* /usr/local/bin/
COPY --from=apiv1/code-server /code-server /code-server
COPY docker.sh code-server.sh init.sh /init.d/
RUN ln -s /code-server/bin/code-server /bin/code-server && chmod +x /init.d/*.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh", "/init.d/init.sh"]