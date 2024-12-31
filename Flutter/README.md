# 配置

[Flutter镜像源配置](../Mirrors/Flutter镜像源配置.md)

# 工具

### fvm

flutter 版本管理器,必装

```shell
dart pub global activate fvm
```

### 代码自动整理命令

[Dart lint](../Dart/lint.md)

```shell
fvm dart fix --apply
```

# 库

### go_router

flutter 页面路由

```shell
fvm flutter pub add go_router
```

### intl_utils

国际化

```shell
fvm flutter pub add intl_utils

# 国际化生成
fvm dart run intl_utils:generate
```

### import_sorter

导入排序

```shell
fvm flutter pub add import_sorter
# 执行 导入排序
fvm dart run import_sorter:main
```
