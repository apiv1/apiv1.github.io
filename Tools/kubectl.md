下载

```shell
UNAME=$(uname)
ARCH=${ARCH:-$(uname -m)}
case "$ARCH" in
x86_64)
    ARCH=amd64
    ;;
*)
    ;;
esac

alias wget='wget --no-check-certificate --timeout=3 --tries=10'
wget "https://dl.k8s.io/release/$(wget -O - https://dl.k8s.io/release/stable.txt)/bin/${UNAME,,}/${ARCH}/kubectl"
```