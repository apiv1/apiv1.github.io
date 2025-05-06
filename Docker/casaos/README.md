```shell
docker run -it --rm --name casa -p 8080:8080 -v "${PWD:-.}/casa:/DATA" -v "/var/run/docker.sock:/var/run/docker.sock" --stop-timeout 60 dockurr/casa
```