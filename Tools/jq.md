# JSON命令行工具

合并两个json
```shell
jq -s '.[0] * .[1]' 1.json 2.json
```