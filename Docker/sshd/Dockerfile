FROM alpine AS sshd
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories && \
  apk add --update --no-cache \
  openssh \
  openssl \
  shadow \
  && \
  printf '#!/bin/sh\nssh-keygen -A\n/usr/sbin/sshd -D -e $*' > /entrypoint.sh && \
  chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

FROM apiv1/dockerd AS dockerd
RUN apk add --update --no-cache \
  openssh \
  openssl \
  shadow \
  && \
  printf '#!/bin/sh\nssh-keygen -A\n/usr/sbin/sshd -D -e $* &\ndockerd ${DOCKERD_OPT}' > /entrypoint.sh && \
  chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

FROM apiv1/docker AS docker
RUN apk add --update --no-cache \
  openssh \
  openssl \
  shadow \
  && \
  printf '#!/bin/sh\nssh-keygen -A\n/usr/sbin/sshd -D -e $*' > /entrypoint.sh && \
  chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]