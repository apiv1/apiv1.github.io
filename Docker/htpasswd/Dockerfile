ARG BUILD_IMAGE="golang:alpine"
ARG RUNTIME_IMAGE="alpine:latest"

FROM ${BUILD_IMAGE} AS builder
ARG GOPROXY="https://goproxy.cn"
RUN GOPROXY=${GOPROXY} GO111MODULE=on CGO_ENABLED=0 GOOS=linux go install github.com/mattn/htpasswd@latest

FROM ${RUNTIME_IMAGE} AS runner
COPY --from=builder /go/bin/htpasswd /usr/local/bin/htpasswd
ENTRYPOINT [ "htpasswd" ]