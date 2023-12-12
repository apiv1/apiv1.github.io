执行
```bash
git clone --depth=1 https://github.com/nvm-sh/nvm ~/.nvm

# 可选: 可以直接执行脚本安装, 不过又要下载一遍. 建议别用
~/.nvm/install.sh
```

放进rc文件:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```