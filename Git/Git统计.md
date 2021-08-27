```bash
git config --global alias.log-format '!git log --pretty=tformat: --numstat'
git config --global alias.count '!awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"\033[31m+\033[0m:%s  \033[32m-\033[0m:%s  \033[33m△\033[0m:%s\n\",add,subs,loc }"'

git config --global alias.who '!git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r'
git config --global alias.total '!git log --format='%aN' | sort -u | while read name; do echo "$name: "; git log-format --author="$name" | git count; done'
```