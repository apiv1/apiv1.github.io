#### 打包compose镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/ruby:compose
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装ruby

[`安装dood`](../docker/README.md#dood)

安装ruby环境

[bash/zsh版本](./ruby.envrc)
[powershell版本](./ruby.ps1)