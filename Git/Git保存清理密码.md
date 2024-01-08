git https 方式保存及清理密码
清除密码
```shell
git config --system --unset credential.helper
```

保存密码
```shell
# 永久记住密码
git config --global credential.helper store

# 临时记住密码（默认15分钟）
git config --global credential.helper cache
　
# 临时记住密码时间
git config credential.helper ‘cache --timeout=3600’
```