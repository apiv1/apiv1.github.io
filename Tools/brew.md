##### 解决：Another active Homebrew update process is already in progress.

报错
```
Error: Another active Homebrew update process is already in progress.
Please wait for it to finish or terminate it to continue.
```

执行
```shell
rm -rf /usr/local/var/homebrew/locks
```