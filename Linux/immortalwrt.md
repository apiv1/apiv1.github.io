[选择固件版本](https://firmware-selector.immortalwrt.org/)
[旁路由设置](https://liuxs.pro/blog/%E6%A0%91%E8%8E%93%E6%B4%BEimmortalwrt%E6%97%81%E8%B7%AF%E7%94%B1%E8%AE%BE%E7%BD%AE/)

[Docker软路由+无线AP](../Docker/immortalwrt/README.md)

### openwrt插件

#### Passwall
* 透明代理无法生效
  解决:
  ```shell
    opkg update
    opkg install iptables
  ```

#### Easytier
* 通过easytier网络无法访问管理页面和远程登录
  解决:
  ```
  网络->防火墙->常规设置->区域
  添加一条记录:
    常规设置: 涵盖的网络, 全选
    高级设置: 涵盖的设备, 全选
    入站出站转发: 全接受
  保存并应用
  也可以按照自己需要来收紧权限
  ```