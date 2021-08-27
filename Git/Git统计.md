```bash
git config --global alias.log-format '!git log --pretty=tformat: --numstat'
git config --global alias.count '!awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"\033[31m+\033[0m:%s  \033[32m-\033[0m:%s  \033[33m△\033[0m:%s\n\",add,subs,loc }"'

git config --global alias.who '!git log --pretty="%aN <%aE>" | sort | uniq -c | sort -k1 -n -r'

git config --global alias.recount '!
show_count() {
    awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"\033[31m+\033[0m:%-6s  \033[32m-\033[0m:%-6s  \033[33m△\033[0m:%-6s\",add,subs,loc }";
};
recount() {
    TOTAL_COMMIT=$(echo $(git log --oneline $@ | wc -l))
    printf "%30s  \033[33m↑\033[0m:%-6s  --- Total ---\n" "$(git log --pretty=tformat: --numstat $@ | show_count)" $TOTAL_COMMIT
    git log --pretty="%aN <%aE>" $@ | sort | uniq -c | sort -k1 -n -r |
    while read count name
    do
        printf "%30s  \033[33m↑\033[0m:%-6s ($(($count*100/$TOTAL_COMMIT))%%) $name\n" "$(git log --pretty=tformat: --numstat --author="$name" $@ | show_count)" $count
    done;
}; recount'
```