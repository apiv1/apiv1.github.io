免安装, nmap使用docker

bash
```shell
alias nmap='docker run --rm -it --net host instrumentisto/nmap'
```

powershell
```powershell
function nmap { docker run --rm -it --net host instrumentisto/nmap $args }
```