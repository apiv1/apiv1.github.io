ARG STAGE_PREFIX

FROM ubuntu:22.04 AS code-server
ARG TARGETOS
ARG TARGETARCH
ARG CODE_SERVER_VERSION=4.20.0
ADD https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/code-server.tar.gz
RUN mkdir /code-server && tar xvf /tmp/code-server.tar.gz -C /code-server --strip-components=1 && rm /tmp/code-server.tar.gz

FROM ${STAGE_PREFIX}code-server AS stage-code-server

FROM apiv1/myvim AS daemon

RUN apt install -y tini curl wget

COPY --from=stage-code-server /code-server /code-server
COPY entrypoint.sh /entrypoint.sh

RUN ln -s /code-server/bin/code-server /bin/code-server && \
  chmod +x /entrypoint.sh

EXPOSE 8443

ENTRYPOINT [ "/entrypoint.sh" ]