### adb 多用户常用命令

### 列出用户

```shell
pm list users
```

### 创建用户

```shell
# 创建普通用户
pm create-user 用户名

# 创建受限用户
pm create-user --restricted 用户名

# 创建访客用户
pm create-user --guest 用户名

# 创建临时用户（重启后消失）
pm create-user --ephemeral 用户名
```

### 切换用户

```shell
am switch-user <用户ID>
```

### 获取当前用户

```shell
am get-current-user
```

### 删除用户

```shell
pm remove-user <用户ID>
```

### 查看用户详情

```shell
dumpsys user
```

### 指定用户执行

```shell
# 列出指定用户的已安装应用
pm list packages --user <用户ID>

# 以指定用户身份运行 adb shell
am start --user <用户ID> -n 包名/Activity
```