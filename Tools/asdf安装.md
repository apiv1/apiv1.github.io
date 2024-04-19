
### 安装

```shell
git clone http://github.com/asdf-vm/asdf.git ~/.asdf
```

### shell配置

```shell
export ASDF_DIR=~/.asdf
test -d "$ASDF_DIR" && . "$ASDF_DIR/asdf.sh" && . "$ASDF_DIR/completions/asdf.bash"
```