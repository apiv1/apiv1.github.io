免安装, wakeonlan使用docker

bash
```shell
alias wakeonlan='docker run --rm -it --net host bltavares/wol awake'
```

script: wakeonlan
```shell
#!/bin/sh
docker run --rm -it --net host bltavares/wol awake $@
```

powershell
```powershell
function global:wakeonlan { docker run --rm -it --net host bltavares/wol awake $args }
```