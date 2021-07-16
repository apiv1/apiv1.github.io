把如下代码存入 CI 变量中, 类型是文件. 例如存为WEWORK_ROBOT
```bash
alias CURL='docker run --network host --rm curlimages/curl:7.77.0'
URL="<url>"
CONTENT='{"msgtype": "text","text":{"content": "'$$*'"}}'
CURL $$URL -H 'Content-Type: application/json' -d "$$CONTENT"
```
sh $WEWORK_ROBOT 要说的话 即可执行. 例如:
```bash
sh $$WEWORK_ROBOT "由 $${CI_COMMIT_AUTHOR} 提交的$${CI_PROJECT_NAME}:$${CI_COMMIT_REF_NAME} 部署完成\n任务地址: $${CI_JOB_URL}"
```