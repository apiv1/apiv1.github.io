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

#### Github DNS

dns服务器设置: 8.8.8.8, 114.114.114.114

/etc/hosts
添加以下
```
#Github Hosts Start
140.82.112.26 alive.github.com
140.82.113.25 live.github.com
185.199.108.154 github.githubassets.com
140.82.113.21 central.github.com
185.199.110.133 desktop.githubusercontent.com
185.199.110.153 assets-cdn.github.com
185.199.110.133 camo.githubusercontent.com
185.199.110.133 github.map.fastly.net
146.75.121.194 github.global.ssl.fastly.net
140.82.121.4 gist.github.com
185.199.111.153 github.io
140.82.121.3 github.com
192.0.66.2 github.blog
140.82.121.5 api.github.com
185.199.108.133 raw.githubusercontent.com
185.199.110.133 user-images.githubusercontent.com
185.199.111.133 favicons.githubusercontent.com
185.199.108.133 avatars5.githubusercontent.com
185.199.111.133 avatars4.githubusercontent.com
185.199.109.133 avatars3.githubusercontent.com
185.199.108.133 avatars2.githubusercontent.com
185.199.108.133 avatars1.githubusercontent.com
185.199.108.133 avatars0.githubusercontent.com
185.199.108.133 avatars.githubusercontent.com
140.82.121.10 codeload.github.com
3.5.28.69 github-cloud.s3.amazonaws.com
54.231.140.73 github-com.s3.amazonaws.com
54.231.135.129 github-production-release-asset-2e65be.s3.amazonaws.com
52.217.161.241 github-production-user-asset-6210df.s3.amazonaws.com
3.5.29.105 github-production-repository-file-5c1aeb.s3.amazonaws.com
185.199.109.153 githubstatus.com
140.82.113.18 github.community
51.137.3.17 github.dev
140.82.113.22 collector.github.com
13.107.42.16 pipelines.actions.githubusercontent.com
185.199.109.133 media.githubusercontent.com
185.199.108.133 cloud.githubusercontent.com
185.199.111.133 objects.githubusercontent.com
#Github Hosts End
```