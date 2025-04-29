配置
```bash
mkdir -p ~/.pip
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
EOF
```
单行
```bash
mkdir -p ~/.pip && printf '[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple\n[install]\ntrusted-host = https://pypi.tuna.tsinghua.edu.cn' > ~/.pip/pip.conf
```

命令
```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple
```

Windows放```$HOME\AppData\Roaming\pip``` 路径