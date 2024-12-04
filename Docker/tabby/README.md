启动

```shell
docker run -it --gpus all -p 11180:8080 -v "${PWD}/.tabby:/data" --restart always --name tabby --init -d -e TABBY_DOWNLOAD_HOST=https://hf-mirror.com tabbyml/tabby serve --model StarCoder-1B --chat-model Qwen2-1.5B-Instruct --device cuda
```

* 若某些包无法下载, 在 [hf-mirror](https://hf-mirror.com) 下载, 放进```.tabby```的对应目录
* VSCODE安装插件: [Tabby](https://marketplace.visualstudio.com/items?itemName=TabbyML.vscode-tabby), 自行配置
