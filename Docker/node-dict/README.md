### build
```shell
docker buildx build . --build-arg v2.0.1 --platform linux/amd64,linux/arm64 --pull --push -t apiv1/node-dict
```

### install
安装dict命令

[bash](./node-dict.envrc)

[powershell](./node-dict.ps1)

### run
```shell
dict abandon
```