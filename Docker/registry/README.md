### 配置dockerd
daemon.json
```json
{
  insecure-registries": ["<ip>:5000"],
  registry-mirrors": ["http://<ip>:5000"]
}
```

### 添加认证用户
```shell
# 安装 htpasswd 命令 (可选, 如果已有就不用安装)
alias htpasswd='docker run --rm -i httpd:2 htpasswd'

# 设置自己的帐号密码
REGISTRY_USERNAME='user'
REGISTRY_PASSWORD='pass'

# 添加认证密码文件
docker compose run --rm -it registry sh -c "echo '"$(htpasswd -Bbn $REGISTRY_USERNAME $REGISTRY_PASSWORD)"' > /auth/htpasswd"
```
