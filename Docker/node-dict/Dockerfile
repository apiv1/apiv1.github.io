FROM node:8.10.0-alpine
RUN npm config set unsafe-perm true && \
    npm config set registry https://registry.npmmirror.com/ && \
    npm config set strict-ssl false && \
    npm -g i node-dict
ENTRYPOINT [ "dict" ]