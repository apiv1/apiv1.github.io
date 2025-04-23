# 软路由使用
Linux下使用Docker配置ImmortalWRT作为AP主路由
* [从固件构建ImmortalWRT镜像](./build-image.md)
* [安装软路由和网桥](immortalwrt.md)
* [安装热点和DNS服务](ap.md)
* [树莓派设置服务延时启动](pi.md)

步骤较多, 因为
* 不同设备的ImmortalWRT固件不通用, 需要自己构建镜像, 构建过程也较多步骤.
* Docker软路由需要设置网络, 且容器状态需要commit到镜像避免丢失数据.
* 主系统要安装配置服务接管wifi, 然后通过网桥分享给Docker, 也需要一些设置.
* 树莓派上热点服务需要延时启动避免热点失效无法连接

设置好后也不需要乱改就能用.经测试重启后也能开启WIFI热点旁路由上网

#### 如果重启后软路由失效或者Wifi连不上密码错误等
* [停止服务](ap.md#停止服务)
* [删除软路由](immortalwrt.md#删除软路由)
* [删除网桥](immortalwrt.md#删除网桥)
* [创建网桥](immortalwrt.md#创建网桥)
* [创建软路由](immortalwrt.md#创建软路由)
* [重启服务](ap.md#重启服务)