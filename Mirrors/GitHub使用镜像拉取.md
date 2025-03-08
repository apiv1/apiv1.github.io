#### Github拉取项目加速

github mirror
```bash
# GITHUB_MIRROR设为镜像源地址
github_mirror() {
  GITHUB_MIRROR=$1
  test -n "$GITHUB_MIRROR" || (echo "usage : github_mirror <url>"; return 1)
  git config --global url."$GITHUB_MIRROR".insteadOf https://github.com/
  git config --global url."https://github.com/".pushInsteadOf https://github.com/
}
```

ssh
```bash
github_mirror "git@github.com:"
```

镜像源 (结尾的/不能少, 否则会有问题)
```
https://kkgithub.com/
https://hub.njuu.cf/
https://hub.nuaa.cf/
https://hub.yzuu.cf/
https://gh.sb250.gq/

https://gitclone.com/
https://ghproxy.com/
https://github.ur1.fun/
```

#### Github下载文件加速

工具[gh-proxy](https://github.com/hunshcn/gh-proxy)

站点
```
https://gh.api.99988866.xyz/
https://github.moeyy.xyz/
```