ARG BUILD_IMAGE="golang:alpine"
ARG RUNTIME_IMAGE="alpine:latest"

FROM ${BUILD_IMAGE} AS builder
ARG GOPROXY="https://goproxy.io"
WORKDIR /app
COPY . /app
RUN GOPROXY=${GOPROXY} GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-linkmode "external" -extldflags "-static"' -o app

FROM ${RUNTIME_IMAGE} AS runner
ARG APP_NAME="app"
COPY --from=builder /app/app /usr/local/bin/${APP_NAME}
RUN ln -s /usr/local/bin/${APP_NAME} /usr/local/bin/entrypoint
ENTRYPOINT [ "entrypoint" ]