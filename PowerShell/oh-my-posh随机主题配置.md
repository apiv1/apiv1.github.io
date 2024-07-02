### 下载安装
二进制包在[这里](https://github.com/JanDeDobbeleer/oh-my-posh/releases), 选对应自己系统的二进制文件下载, 放进PATH环境变量中.
```powershell
if(Get-Command -ErrorAction SilentlyContinue winver) {
  $PATH_SEPERATOR=";"
} else {
  $PATH_SEPERATOR=":"
}
$env:PATH += "$PATH_SEPERATOR$HOME/.bin"
```
比如下载好了放在 ```$HOME/.bin``` 文件夹里

### 下载oh-my-posh主题
```powershell
git clone https://github.com/JanDeDobbeleer/oh-my-posh ~/.oh-my-posh
```

### 配置
打开 ```$PROFILE.CurrentUserAllHosts``` 文件
```powershell
$THEME_PATH = "~/.oh-my-posh/themes/"
$RANDOM_THEME_NAME = (Get-ChildItem $THEME_PATH"*.omp.json" | Get-Random).Name
Write-Output "theme => $RANDOM_THEME_NAME"
$CONFIG_PATH = $THEME_PATH + $RANDOM_THEME_NAME
(@(& oh-my-posh init (& oh-my-posh get shell) --config=$CONFIG_PATH --print) -join "`n") | Invoke-Expression
```