# JSON命令行工具

### 合并两个json
```shell
jq -s '.[0] * .[1]' 1.json 2.json
```

### 使用jq解析json数组例子
```shell
wget -qO - "https://api.github.com/orgs/$ORG/repos?page=0&per_page=1000000000000000" | jq -r '.[].clone_url'
```