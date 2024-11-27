### [安装protoc](https://github.com/protocolbuffers/protobuf/releases)

### Go 支持

```shell
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

生成

proto.go

```golang
//go:generate protoc --go_out=. --go-grpc_out=. ./proto/*.proto
```

生成命令

```shell
go generate ./...
```

### Dart 支持

```shell
dart pub global activate protoc_plugin
```

生成命令

```shell
protoc --dart_out=grpc:lib ./proto/*.proto
```
