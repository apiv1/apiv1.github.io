### compose 启动: [compose.yml配置文件](./compose.yml)

### 直接启动
```shell
OLLAMA_DATA=ollama_data # bash/zsh
$OLLAMA_DATA="ollama_data" # powershell

# 指定models路径(可选), 当前文件夹.ollama
$env:OLLAMA_MODELS='$PWD\.ollama\models' # Windows
OLLAMA_MODELS="$PWD/.ollama/models" # Linux/Mac

# 使用CUDA
$env:OLLAMA_GPU_LAYER="cuda"
OLLAMA_GPU_LAYER="cuda"

ollama serve # 启动后端

# 打开另一个shell
ollama ls # 查看下载的模型
ollama run <模型名> # 启动
```

### docker run 启动
```shell
# 启动服务
docker run --rm --name ollama -e OLLAMA_HOST=0.0.0.0:11434 -d -p 11434:11434 -v "${OLLAMA_DATA}:/root/.ollama" ollama/ollama

# 启动服务(使用gpu, 需要配置docker服务, 开启gpu容器支持)
docker run --gpus all --rm --name ollama -e OLLAMA_HOST=0.0.0.0:11434 -d -p 11434:11434 -v "${OLLAMA_DATA}:/root/.ollama" ollama/ollama

# 命令交互
docker exec -e OLLAMA_HOST=0.0.0.0:11434 -it ollama ollama run llama3.1

docker run -it --rm --name ollama-client --add-host host.docker.internal:host-gateway -e OLLAMA_HOST=host.docker.internal:11434 ollama/ollama run llama3.1

# 停止服务
docker stop ollama
```

### 装CUDA驱动(使用GPU)
[下载](https://developer.nvidia.com/cuda-downloads)

### Ubuntu开启nvidia容器支持
[参考网站](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
可能会遇到apt从nvidia.github.io下载清单和包受阻的情况, 需要给[APT配置代理](../../Linux/Apt使用代理.md)

-------

* golang和ollama交互例子 [client.go](./client/main.go)