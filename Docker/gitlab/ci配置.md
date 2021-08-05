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
- IMAGE_NAME
```bash
sh $$DOCKER_LOGIN
sh $$WEWORK_ROBOT "任务地址: $${CI_JOB_URL}\n版本: $${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}\n镜像: $${IMAGE_NAME}\n提交者: $${CI_COMMIT_AUTHOR}\n状态: 部署中"
```

### POST_TRIGGER
- WEWORK_ROBOT
- IMAGE_NAME
```bash
sh $$WEWORK_ROBOT "任务地址: $${CI_JOB_URL}\n版本: $${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME}\n镜像: $${IMAGE_NAME}\n提交者: $${CI_COMMIT_AUTHOR}\n状态: 部署完成"
sh $$DOCKER_LOGOUT
```

### WEWORK_ROBOT
- WEBHOOK_URL
```bash
alias CURL='docker run --network host --rm curlimages/curl:7.77.0'
CONTENT='{"msgtype": "text","text":{"content": "'$$*'"}}'
CURL -sSL $$WEBHOOK_URL -H 'Content-Type: application/json' -d "$$CONTENT"
```