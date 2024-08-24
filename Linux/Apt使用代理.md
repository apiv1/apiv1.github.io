临时
```shell
alias apt='sudo apt -o Acquire::http::proxy="socks5h://127.0.0.1:1080/"' # socks5代理
alias apt='sudo apt -o Acquire::http::proxy="http://127.0.0.1:3128/"' # http代理
apt update
```