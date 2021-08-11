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
- WEWORK_ROBOT
- DEPLOY_MESSAGE
- DOCKER_LOGIN
```bash
. $$DEPLOY_MESSAGE
sh $$WEWORK_ROBOT \
"$${DEPLOY_MESSAGE}
状态: 部署中"
sh $$DOCKER_LOGIN
```

### POST_TRIGGER
- WEWORK_ROBOT
- DEPLOY_MESSAGE
- DOCKER_LOGOUT
```bash
. $$DEPLOY_MESSAGE
sh $$WEWORK_ROBOT \
"$${DEPLOY_MESSAGE}
状态: 部署完成"
sh $$DOCKER_LOGOUT
```

### WEWORK_ROBOT
- WEBHOOK_URL
```bash
alias wget='docker run --rm mwendler/wget'
CONTENT='{"msgtype": "text","text":{"content": "'$$*'"}}'
wget -O - --no-check-certificate --method=POST --body-data="$$CONTENT" $$WEBHOOK_URL
```

### REF_MESSAGE
```bash
REF_MESSAGE=$$(git tag -l $$CI_COMMIT_TAG --format '%(contents)')
```

### DEPLOY_MESSAGE
- REF_MESSAGE
- IMAGE_NAME
```bash
. $$REF_MESSAGE
DEPLOY_MESSAGE=$$(echo \
"任务地址: $${CI_JOB_URL}
版本:$${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}
镜像: $${IMAGE_NAME}
提交者: $${CI_COMMIT_AUTHOR}
信息:
- - - - - - - - - - - - - - - - - -
$${REF_MESSAGE}
- - - - - - - - - - - - - - - - - -
")
```