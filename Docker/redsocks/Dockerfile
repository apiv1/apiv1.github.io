FROM ubuntu:22.04 AS base

FROM base as base_private
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq redsocks iptables && \
  rm -rf /var/lib/apt/lists/*

COPY --from=base /etc/apt/sources.list /etc/apt/sources.list

COPY redsocks.tmpl whitelist.txt /etc/
COPY redsocks.sh redsocks-fw.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/redsocks.sh"]