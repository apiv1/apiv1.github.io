ARG BUILD_IMAGE="golang:alpine"
ARG RUNTIME_IMAGE="scratch"

FROM ${BUILD_IMAGE} AS builder
ARG GOPROXY="https://goproxy.cn,https://goproxy.io,direct"
WORKDIR /app
COPY . /app
RUN GOPROXY=${GOPROXY} GO111MODULE=on CGO_ENABLED=0 GOOS=linux go build -ldflags '-s -w' -o app

FROM ${RUNTIME_IMAGE} AS runner
COPY --from=builder /app/app /aes
ENV PATH "/:$PATH"
ENTRYPOINT [ "aes" ]