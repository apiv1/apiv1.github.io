#### 使用 [g](https://github.com/voidint/g)

Bash

```shell
export GOPROXY=https://goproxy.cn,https://goproxy.io,direct
export GO111MODULE=on
export G_EXPERIMENTAL=true
export G_MIRROR=https://golang.google.cn/dl/
export G_HOME="$HOME/.g"
export GOPATH="$G_HOME/gopath"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
```

Powershell

```powershell
$env:GOPROXY="https://goproxy.cn,https://goproxy.io,direct"
$env:GO111MODULE="on"
$env:G_EXPERIMENTAL="true"
$env:G_MIRROR="https://golang.google.cn/dl/"
$env:G_HOME="$HOME/.g"
$env:GOPATH = "$env:G_HOME/gopath"
$env:GOBIN="$env:GOPATH/bin"

if(Get-Command -ErrorAction SilentlyContinue winver) {
  $PATH_SEPERATOR=";"
} else {
  $PATH_SEPERATOR=":"
}
$env:PATH += "$PATH_SEPERATOR$env:GOBIN"
```

安装工具
```shell
go install -v golang.org/x/tools/gopls@latest
go install -v golang.org/x/tools/cmd/goimports@latest
go install -v honnef.co/go/tools/cmd/staticcheck@latest
```