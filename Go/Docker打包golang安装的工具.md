举例打包dlv

```shell
export DOCKERFILE='
ARG BUILD_IMAGE="golang:alpine"
ARG RUNTIME_IMAGE="alpine:latest"

FROM ${BUILD_IMAGE} AS builder
ARG GOPROXY="https://goproxy.cn,https://goproxy.io,direct"
RUN export GOPROXY=${GOPROXY} GO111MODULE=on CGO_ENABLED=0 GOOS=linux; \
  go install github.com/go-delve/delve/cmd/dlv@latest;

FROM ${RUNTIME_IMAGE} AS runner
COPY --from=builder /go/bin/* /usr/local/bin/
'

echo $DOCKERFILE | docker buildx build -f - . -t dlv
```