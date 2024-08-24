compose 启动: [compose.yml配置文件](./compose.yml)
```shell
# 启动服务
docker compose up -d

# 命令交互
docker compose exec ollama ollama run llama3.1
```

docker run 启动
```shell
# 启动服务
docker run --rm --name ollama -d -p 11434:11434 -v ollama_data:/root/.ollama ollama/ollama

# 命令交互
docker exec ollama ollama run llama3.1
```