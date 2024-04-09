FROM linuxserver/openssh-server
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories && \
  apk add --no-cache --update iptables