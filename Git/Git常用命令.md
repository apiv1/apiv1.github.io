### 常用命令
```bash
git config --global init.defaultBranch dev # 初始化默认分支为dev
git config --global pull.rebase true # git pull强制使用--rebase选项
git config --global http.postBuffer 5G # 设置提交大小上限
```

代理
```bash
# 设置
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 取消
git config --global --unset http.proxy
git config --global --unset https.proxy

```

设置替换url
```bash
git config --global url."git@$DOMAIN_NAME:".insteadOf "https://$DOMAIN_NAME/" # ssh 替换 https
git config --global url."https://$DOMAIN_NAME/".insteadOf "git@$DOMAIN_NAME:" # https 替换 ssh
```

参考[配置 Git 处理行结束符](https://docs.github.com/zh/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)
```bash
git config --global core.autocrlf false # 关闭自动替换换行符

# 多系统项目协作时
git config --global core.autocrlf true # Windows使用这个
git config --global core.autocrlf input # Linux,Mac使用这个
```

```shell
# Git LFS错误: Encountered 7 file(s) that should have been pointers
git rm --cached -r .;git reset --hard;git rm .gitattributes;git reset .;git checkout .

# 简化版
git rm .gitattributes; git reset --hard HEAD
```

```shell
# 环境变量, 跳过证书校验
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
```

```shell
# 忽略权限 (全局设置无效)
git config core.filemode false
```

```shell
# 安全目录
git config --global safe.directory '*'
```

```shell
# 证书设置存储
git config --global credential.helper store
```

```shell
# 使用git时候出现error setting certificate verify locations: CAfile:问题
git config --system http.sslverify false
```

### ~/.ssh/config
参考例子
```config
Host github.com
    HostName ssh.github.com
    User git
    Port 443
    IdentityFile ~/.ssh/id_rsa
Host *
    ServerAliveInterval  60
    ServerAliveCountMax  60
    ConnectTimeout 30
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
    HostkeyAlgorithms +ssh-rsa
```