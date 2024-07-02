### Bash

配置文件

```shell
export FLUTTER_GIT_URL=https://gitee.com/mirrors/Flutter.git
export FVM_FLUTTER_URL=https://gitee.com/mirrors/Flutter.git
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FVM_CACHE_PATH="~/.fvm" # 缓存目录
export PUB_CACHE="~/.pub-cache" # pub cache 目录, 不设置的话 windows: ~\AppData\Local\Pub\Cache, Mac/Linux: ~/.pub-cache
export FLUTTER_HOME="~/flutter"
```

执行命令

```shell
git clone "$FLUTTER_GIT_URL" "$FLUTTER_HOME"
```

### Powershell

配置文件

```powershell
$env:FLUTTER_GIT_URL="https://gitee.com/mirrors/Flutter.git"
$env:FVM_FLUTTER_URL="https://gitee.com/mirrors/Flutter.git"
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn";
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
$env:FVM_CACHE_PATH="$HOME/.fvm" # 缓存目录
$env:PUB_CACHE="$HOME/.pub-cache" # pub cache 目录, 不设置的话 windows: ~\AppData\Local\Pub\Cache, Mac/Linux: ~/.pub-cache
$env:FLUTTER_HOME="$HOME/flutter"

if(Get-Command -ErrorAction SilentlyContinue winver) {
  $PATH_SEPERATOR=";"
} else {
  $PATH_SEPERATOR=":"
}

$env:PATH += "$PATH_SEPERATOR$env:FLUTTER_HOME/bin"
$env:PATH += "$PATH_SEPERATOR$env:PUB_CACHE/bin"
```

执行命令

```powershell
git clone "$env:FLUTTER_GIT_URL" "$env:FLUTTER_HOME"
```

FVM_GIT_CACHE 改名为 FVM_FLUTTER_URL
FVM_HOME 改名为 FVM_CACHE_PATH
