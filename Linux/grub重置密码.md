* Grub菜单按e
* 编辑 linux那行， 里面的ro改成rw（不设置这个无法改文件），最后添加init=/bin/bash
* 按Ctrl+X重启
* 进入系统后```cat /etc/passwd``` 查看帐号
* ```passwd 帐号名```直接改密码