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

### 中文搜索匹配

使用正则表达式
```
(.[\u4E00-\u9FA5]+)|([\u4E00-\u9FA5]+.)
```

### 远程VSCode
#### 杀code-server进程(重置环境变量用)
```shell
pids=$(ps -ef | grep vscode-server| grep -v grep | awk '{print $2}')
for pid in $pids
do
    kill -9 $pid
done
```
#### 环境变量配置
使用的是Interactive login的方式，这种方式会加载/etc/profile、~/.bash_profile 、~/.bash_login /，默认并不会加载 ~/.bashrc
```shell
vi ~/.bash_profile
```