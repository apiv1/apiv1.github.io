# Stringer
自动生成类对象的String()内容

### Install
```shell
go get golang.org/x/tools/cmd/stringer
```

### Sample
loglevel/loglevel.go
```go
package loglevel
type LogLevel int

//go:generate stringer -type=LogLevel -linecomment
const (
	NONE LogLevel = iota // 无
	ERROR // 错误
	WARNING //警告
	INFO //信息
	DEBUG //调试
	VERBOSE //详细
)
```