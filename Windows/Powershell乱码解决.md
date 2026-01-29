在脚本里， 或者临时会话里执行
```powershell
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
```
$false 表示不带BOM的UTF-8