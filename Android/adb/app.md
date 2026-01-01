### 用adb命令下载手机里安装的某个apk

首先通过以下命令查找该应用的apk路径（以包名`com.example.app`为例）：

```shell
adb shell pm path com.example.app
```

输出类似于：
```
package:/data/app/com.example.app-1/base.apk
```

然后使用adb命令将apk导出到电脑（假设路径为上面查到的 `/data/app/com.example.app-1/base.apk`）：

```shell
adb pull /data/app/com.example.app-1/base.apk .
```

上述命令会把apk下载到当前目录。

### 单命令版

```shell
PKG="com.example.app"
adb pull "$(adb shell pm path "$PKG" | sed 's/package://')" "$PKG".apk
```

#### PowerShell 单命令版本

```powershell
$pkg = "com.example.app"
adb pull (adb shell pm path $pkg | ForEach-Object { $_ -replace "package:", "" }) "$pkg.apk"
```
