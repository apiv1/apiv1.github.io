```bash
git config --global alias.log-format '!git log --pretty=tformat: --numstat'
git config --global alias.count '!awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"\033[31m+\033[0m:%s  \033[32m-\033[0m:%s  \033[33m△\033[0m:%s\n\",add,subs,loc }"'
```