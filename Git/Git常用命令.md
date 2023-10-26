```bash
git config --global init.defaultBranch dev # 初始化默认分支为dev
git config --global pull.rebase true # git pull强制使用--rebase选项
git config --global http.postBuffer 5G # 设置提交大小上限
```

```bash
git config --global url."git@$DOMAIN_NAME:".insteadOf "https://$DOMAIN_NAME/" # ssh 替换 https
git config --global url."https://$DOMAIN_NAME/".insteadOf "git@$DOMAIN_NAME:" # https 替换 ssh
```

```bash
git config --global core.autocrlf false # 关闭自动替换换行符
```

```shell
# Git LFS错误: Encountered 7 file(s) that should have been pointers
git rm --cached -r .;git reset --hard;git rm .gitattributes;git reset .;git checkout .
```