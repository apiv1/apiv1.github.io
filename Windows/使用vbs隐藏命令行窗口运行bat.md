hiderun.vbs
```vbs
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "%comspec% /c ping -t localhost", 0
```