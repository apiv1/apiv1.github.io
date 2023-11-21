快捷键
```
Ctrl+c                     通常复制
Ctrl+x                      通常是剪切
Ctrl+v                        通常粘贴   （但仅在 Android >= 7 上支持）
MOD+f                      全屏
MOD+ [ ←   → ]       （向左向右旋转）
MOD+s                       最近任务
MOD+g                        将窗口大小调整为 1:1
MOD+w | 双击左键¹      调整窗口大小以去除黑边
MOD+h | 中键单击        点击 HOME
MOD+b | 右键单击²     点击返回
MOD+m                  （）
MOD+↑↓                  （   音量加减）
MOD+p               点击电源键
MOD+o               关闭设备屏幕（保持镜像）
MOD+Shift+o      打开设备屏幕
MOD+r                切换横屏竖屏。 [ alt+r ]
MOD+n               展开通知面板
```

常用组合
```
 -Sw -m600 -b4M --window-borderless
--window-x 100 --window-y 100 --window-width 800 --window-height 600 
--shortcut-mod=rctrl
--no-key-repeat        避免转发重复的关键事件

--shortcut-mod=rctrl    更改快捷键:    可能的键有 lctrl、rctrl、lalt、ralt、lsuper 和 rsuper。

--push-target=/sdcard/Movies/       [   /sdcard/Movies/ =手机中文件目录 ]更改传输目录

--window-title xxx              配置标题

--window-x 100 --window-y 100 --window-width 800 --window-height 600    位置和大小

--window-borderless        无边界

--always-on-top            总在最前

--rotation 1                 #可能的值是: # 0：不旋转 # 1：逆时针90度 # 2：180度 # 3：顺时针90度

-w                    息屏投屏

-S                     关闭屏幕  一般用 -Sw

-n                    要禁用控件（可以与设备交互的所有内容：输入键、鼠标事件、拖放文件）：

 -v                    版本信息

--help                  帮助
-c 800:800:0:0    **裁剪投屏屏幕(长:宽:偏移x:偏移y)**将某一区域放大-p 27184  设置端口
-m 1024              缩小尺寸
-b 2M                修改比特率
--lock-video-orientation=0    0=正常 1=90° 2=180° 3=270° 设置方向

--encoder OMX.qcom.video.encoder.avc  设置编码器
 -r file.mkv   录屏
```