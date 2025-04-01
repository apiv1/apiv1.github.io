
### 安装

```shell
git clone http://github.com/asdf-vm/asdf.git ~/.asdf
```

### shell配置

```shell
export ASDF_DIR=~/.asdf
test -d "$ASDF_DIR" && . "$ASDF_DIR/asdf.sh" && . "$ASDF_DIR/completions/asdf.bash"
```

### 新asdf安装

* 下载二进制包 [Release](https://github.com/asdf-vm/asdf/releases)

* golang 安装 ```go install github.com/asdf-vm/asdf/cmd/asdf@v0.16.0```