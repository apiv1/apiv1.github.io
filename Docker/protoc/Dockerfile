FROM netdata/wget AS base
ARG TARGETOS
ARG TARGETARCH
ARG PROTOC_VERSION=29.2
ARG ALPINE_PROXY="mirrors.ustc.edu.cn"
RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_PROXY}/g" /etc/apk/repositories && \
  apk add --no-cache --update unzip
RUN export PROTOC_ARCH=$(uname -m); \
  test "${PROTOC_ARCH}" = aarch64 && export PROTOC_ARCH=aarch_64; \
  wget -O /tmp/protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-${TARGETOS}-${PROTOC_ARCH}.zip && \
  unzip /tmp/protoc.zip -d /protoc && rm /tmp/protoc.zip

FROM alpine AS deploy
COPY --from=base /protoc/bin/* /usr/local/bin/
COPY --from=base /protoc/include/* /usr/local/include/
ENTRYPOINT [ "protoc" ]