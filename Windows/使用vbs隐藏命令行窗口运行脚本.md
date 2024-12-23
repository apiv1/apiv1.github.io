## hiderun.vbs
隐藏执行run.bat
```vbs
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "%comspec% /c run.bat", 0
```

无限循环执行 ping localhost 命令, 可以替换成其他命令.
run.bat
```cmd
for /l %%a in (0,0,1) ping localhost
```

## 执行ps1脚本
```vbs
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "powershell -noexit -file C:\ps1\run.ps1", 0
```