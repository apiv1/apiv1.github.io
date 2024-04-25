### Mac命令行启动

```bash
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
```

```powershell
New-Alias -Name code -Value '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
```

### Vscode 禁用 Java插件随便格式化乱换行

settings.json

```json
{
  "java.format.enabled": false
}
```