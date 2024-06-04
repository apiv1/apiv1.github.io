```shell
export FLUTTER_GIT_URL=https://gitee.com/mirrors/Flutter.git
export FVM_FLUTTER_URL=https://gitee.com/mirrors/Flutter.git
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

```powershell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn";
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

```shell
export FVM_CACHE_PATH # 缓存目录
export PUB_CACHE # pub cache 目录, 不设置的话 windows: ~\AppData\Local\Pub\Cache, Mac/Linux: ~/.pub-cache
```

FVM_GIT_CACHE 改名为 FVM_FLUTTER_URL
FVM_HOME 改名为 FVM_CACHE_PATH