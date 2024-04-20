# [Chrome完整包下载地址](https://www.google.cn/chrome/?standalone=1&extra=stablechannel)

# 插件手动安装方法
1. 点开[chrome://extensions](chrome://extensions)插件页面, 勾选```开发者模式```.
2. crx文件下载下来后改扩展名成zip, 拖到插件页面安装.

### 浏览器代理
[SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega): [下载](https://github.com/FelisCatus/SwitchyOmega/releases)


### 'crypto.subtle' is not available so webviews will not work 问题解决
原因: http不允许运行某些code-server组件<br>
解决方法: [chrome://flags/#unsafely-treat-insecure-origin-as-secure](chrome://flags/#unsafely-treat-insecure-origin-as-secure). 设置为enable并添加 http的url<br>


### ubuntu更改主机名，重启电脑打不开谷歌浏览器
```shell
rm -rf ~/.config/google-chrome/Singleton*
```