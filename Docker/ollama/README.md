### compose 启动: [compose.yml配置文件](./compose.yml)
```shell
# 启动服务
docker compose up -d

# 命令交互
docker compose exec ollama ollama run llama3.1

# 停止服务
docker compose down
```

### docker run 启动
```shell
# 启动服务
docker run --rm --name ollama -d -p 11434:11434 -v ollama_data:/root/.ollama ollama/ollama

# 启动服务(使用gpu, 需要配置docker服务, 开启gpu容器支持)
docker run --gpus all --rm --name ollama -d -p 11434:11434 -v ollama_data:/root/.ollama ollama/ollama

# 命令交互
docker exec -it ollama ollama run llama3.1

# 停止服务
docker stop ollama
```

### Ubuntu开启nvidia容器支持
[参考网站](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
可能会遇到apt从nvidia.github.io下载清单和包受阻的情况, 需要给[APT配置代理](../../Linux/Apt使用代理.md)

-------

* golang和ollama交互例子 [client.go](./client/main.go)