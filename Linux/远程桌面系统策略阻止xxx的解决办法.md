```
编辑
/usr/share/polkit-1/actions/org.freedesktop.NetworkManager.policy
文件

搜索阻止的提示文字

<allow_any>XXXXXX</allow_any> 改成 <allow_any>auth_self_keep</allow_any>
```