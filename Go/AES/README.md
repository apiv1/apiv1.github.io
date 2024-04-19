### build

```bash
docker build . --build-arg APP_NAME=aes -t apiv1/aes
docker buildx build . --build-arg APP_NAME=aes --platform linux/amd64,linux/arm64 --push -t apiv1/aes # buildkit
```

bash

```shell
aes() {
  docker run --rm -it -e AES_KEY="$AES_KEY" -v "$PWD:$PWD" -w "$PWD"  apiv1/aes $*
}
```

powershell

```powershell
function global:aes() {
  docker run --rm -it -e AES_KEY="${AES_KEY}" -v "$(${PWD}.Path):/pwd" -w "/pwd"  apiv1/aes $args
}
```
