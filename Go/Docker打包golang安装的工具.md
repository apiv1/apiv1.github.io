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

启动调试
```shell
dlv --listen=:2345 --headless=true --api-version=2 exec --only-same-user=false ./your-go-program # 等待调试器连接后才运行
dlv --listen=:2345 --headless=true --api-version=2 exec --only-same-user=false --accept-multiclient --continue ./your-go-program # 不等待调试器, 直接运行
```

附加调试
```shell
# 在容器内部的 shell 中
dlv attach <Go-Program-PID> --listen=:2345 --headless=true --api-version=2
```