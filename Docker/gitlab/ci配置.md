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
- DOCKER_LOGIN
- WEWORK_ROBOT
- IMAGE_NAME
- REF_MESSAGE
```bash
sh $$DOCKER_LOGIN
. $$REF_MESSAGE
sh $$WEWORK_ROBOT "任务地址: $${CI_JOB_URL}\n版本: $${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}\n镜像: $${IMAGE_NAME}\n提交者: $${CI_COMMIT_AUTHOR}\n信息: $${REF_MESSAGE}\n状态: 部署中"
```

### POST_TRIGGER
- WEWORK_ROBOT
- IMAGE_NAME
- REF_MESSAGE
- DOCKER_LOGOUT
```bash
. $$REF_MESSAGE
sh $$WEWORK_ROBOT "任务地址: $${CI_JOB_URL}\n版本: $${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}\n镜像: $${IMAGE_NAME}\n提交者: $${CI_COMMIT_AUTHOR}\n信息: $${REF_MESSAGE}\n状态: 部署完成"
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