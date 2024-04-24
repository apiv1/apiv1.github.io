FROM node:8.10.0-alpine
ARG VERSION=v2.0.1
RUN npm config set unsafe-perm true && \
    npm config set registry https://registry.npmmirror.com/ && \
    npm config set strict-ssl false && \
    npm -g i node-dict@${VERSION}
ENTRYPOINT [ "dict" ]