使用patch命令变更deploy的镜像拉取策略
```shell
DEPLOY_NAME=''
CONTAINER_NAME=''
kubectl patch deploy $DEPLOY_NAME -p '{"spec":{"template":{"spec":{"containers":[{"name":"'$CONTAINER_NAME'","imagePullPolicy":"IfNotPresent"}]}}}}'
```