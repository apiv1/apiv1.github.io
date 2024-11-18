### 获取github org下所有项目地址(使用jq解析json返回)
```shell
export ORG='项目名'

wget -qO - "https://api.github.com/orgs/$ORG/repos?page=0&per_page=1000000000000000" | jq -r '.[].ssh_url' # ssh url
wget -qO - "https://api.github.com/orgs/$ORG/repos?page=0&per_page=1000000000000000" | jq -r '.[].clone_url' # https url
```