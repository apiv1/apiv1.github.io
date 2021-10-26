```bash
git config --global alias.log-format '!git log --pretty=tformat: --numstat'
git config --global alias.count '!awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"\033[31m+\033[0m:%s  \033[32m-\033[0m:%s  \033[33m△\033[0m:%s\n\",add,subs,loc }"'

git config --global alias.who '!git log --pretty="%aN <%aE>" | sort | uniq -c | sort -k1 -n -r'

git config --global alias.recount '!
_count() {
    awk "{ add += \$1 ; subs += \$2 ; loc += \$1 - \$2 } END { printf \"%s  %s  %s\",add,subs,loc }"
}
recount() {
    TOTAL_COMMIT=$(echo $(git log --oneline $@ | wc -l))
    TOTAL=$(git log --pretty=tformat: --numstat $@ | _count)
    TOTAL_ADD=$(echo $TOTAL | awk "{print \$1}") TOTAL_SUBS=$(echo $TOTAL | awk "{print \$2}") TOTAL_LOC=$(echo $TOTAL | awk "{print \$3}")
    printf "\033[31m+\033[0m:%-8s  \033[32m-\033[0m:%-8s  \033[33m△\033[0m:%-12s  \033[33m↑\033[0m:%-12s  --- Total ---\n" $TOTAL_ADD $TOTAL_SUBS $TOTAL_LOC $TOTAL_COMMIT
    git log --pretty="%aN <%aE>" $@ | sort | uniq -c | sort -k1 -n -r |
    while read count name
    do
        LOCAL=$(git log --pretty=tformat: --numstat --author="$name" $@ | _count)
        LOCAL_ADD=$(echo $LOCAL | awk "{print \$1}") LOCAL_SUBS=$(echo $LOCAL | awk "{print \$2}") LOCAL_LOC=$(echo $LOCAL | awk "{print \$3}")
        printf "\033[31m+\033[0m:%-8s  \033[32m-\033[0m:%-8s  \033[33m△\033[0m:%-12s  \033[33m↑\033[0m:%-12s $name\n" $LOCAL_ADD $LOCAL_SUBS "$LOCAL_LOC($(($LOCAL_LOC*100/$TOTAL_LOC))%)" "$count($(($count*100/$TOTAL_COMMIT))%)"
    done;
}; recount'
```