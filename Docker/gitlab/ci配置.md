## 变量

### USE_DOCKER
```bash
1 # 使用 docker
0 # 不用 docker
```

## 文件

### DOCKER_LOGIN
- CI_REGISTRY_PASSWORD
```bash
docker login $$CI_REGISTRY -u $$CI_REGISTRY_USER -p $$CI_REGISTRY_PASSWORD
```

### DOCKER_LOGOUT
```bash
docker logout $$CI_REGISTRY
docker rmi $$(docker images -a | grep none | awk '{print $$3}') || exit 0
```

### DEPLOY_TRIGGER
- IMAGE_NAME
```bash
kubectl set image deploy -lapp=$${CI_PROJECT_NAME} '*'=$${IMAGE_NAME}
```

### PRE_TRIGGER
- WEBHOOK_CALLER
- DEPLOY_MESSAGE
- DOCKER_LOGIN
```bash
. $$DEPLOY_MESSAGE
sh $$WEBHOOK_CALLER \
"$${DEPLOY_MESSAGE}
状态: 部署中"
test "$${USE_DOCKER:-1}" = '1' && sh $$DOCKER_LOGIN
```

### POST_TRIGGER
- WEBHOOK_CALLER
- DEPLOY_MESSAGE
- DOCKER_LOGOUT
```bash
export DEPLOY_EXIT_CODE=$${DEPLOY_EXIT_CODE:-0}
export DEPLOY_RESULT_MSG=$$(test "$${DEPLOY_EXIT_CODE}" = '0' && echo '成功' || echo '失败')

. $$DEPLOY_MESSAGE
sh $$WEBHOOK_CALLER \
"$${DEPLOY_MESSAGE}
状态: 部署$${DEPLOY_RESULT_MSG}"
test "$${USE_DOCKER:-1}" = '1' && sh $$DOCKER_LOGOUT

test "$${DEPLOY_EXIT_CODE}" = '0' && test -f "$${PROJECT_POST_TRIGGER}" && sh "$${PROJECT_POST_TRIGGER}" || :
```

### WEBHOOK_CALLER
- WEBHOOK_URL
```bash
test "$${USE_DOCKER:-1}" = '1' && alias wget='docker run --rm mwendler/wget'
CONTENT='{"msgtype": "markdown","markdown":{"content": "'$$*'"}}'
CONTENT=$$(echo "$$CONTENT" | sed ':a;N;s/\n/\\n/;t a')
wget -O - --no-check-certificate --method=POST --body-data="$$CONTENT" $$WEBHOOK_URL
```

### REF_MESSAGE
```bash
REF_MESSAGE=$$(git tag -l $$CI_COMMIT_TAG --format '%(contents)')
```

### DEPLOY_MESSAGE
- REF_MESSAGE
```bash
. $$REF_MESSAGE
DEPLOY_MESSAGE=$$(echo \
"任务版本: [$${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}]($${CI_JOB_URL})
地址: [$${CI_JOB_URL}]($${CI_JOB_URL})
提交者: $${CI_COMMIT_AUTHOR}
阶段: $${CI_JOB_STAGE}
任务: $${CI_JOB_NAME}
信息:
- - - - - - - - - - - - - - - - - -
$${REF_MESSAGE}
- - - - - - - - - - - - - - - - - -
")
```

## Tips

* 在windows下使用Powershell执行会中文乱码, 在 Windows 控制面板-时钟和区域-区域-管理-更改系统区域设置, 勾选<使用Unicode Utf-8提供全球语言支持>