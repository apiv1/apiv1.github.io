免安装, netcat使用docker

bash

```shell
alias netcat='docker run --rm -it --net host --init toolbelt/netcat'
```

powershell

```powershell
function netcat { docker run --rm -it --net host --init toolbelt/netcat $args }
```