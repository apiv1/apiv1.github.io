#### 打包dind镜像

```shell
# 准备打包
export DOCKER_COMPOSE_IMAGE=apiv1/ruby:dind
cp *compose*.yml ../docker-compose/
cd ../docker-compose
```

执行: [`打包 compose.yml 到镜像`](../docker-compose/README.md#打包配置到镜像-示例)

#### 函数式安装ruby

[`安装docker-dind`](../docker-compose/README.md#docker-dind)

安装ruby环境

bash
```shell
cd $DOCKER_HOME/.envrc.d
echo \
'RUBY_IMAGE=ruby:alpine
ruby-compose () {
  docker-dind apiv1/ruby:dind --project-directory "$PWD" -f /compose.yml $*
}
ruby-env () {
  ruby-compose run --rm --entrypoint sh ruby $*
}
ruby-cli () {
  ruby-compose run --rm ruby $*
}'\
> ruby.envrc
cd -
```

powershell
```powershell
$RUBY_IMAGE='ruby:alpine'
function ruby-compose () {
  docker-dind apiv1/ruby:dind --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}
function ruby-env () {
  ruby-compose run --rm --entrypoint sh ruby $($args -join ' ')
}
function ruby-cli () {
  ruby-compose run --rm ruby $($args -join ' ')
}
```