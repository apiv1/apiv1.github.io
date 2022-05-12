### build
```bash
docker build . --build-arg APP_NAME=httpserver -t apiv1/httpserver
docker buildx build . --build-arg APP_NAME=httpserver --platform linux/amd64,linux/arm64 --push -t apiv1/httpserver # buildkit
```

### run
```bash
docker run --rm -v $PWD:/data -p 8088:8088 apiv1/httpserver /data
docker run --rm -v $PWD:/data --network host apiv1/httpserver /data
```