```shell
cd /opt/k3s/
docker run -d --name k3s --restart always --network host --hostname $(hostname) --privileged -v $PWD:/opt/k3s rancher/k3s:v1.31.2-k3s1 server --disable agent --disable traefik --config /opt/k3s/config.yaml --data-dir /opt/k3s/lib/k3s --private-registry /opt/k3s/registries.yaml --default-local-storage-path /opt/k3s/storage --log /opt/k3s/log/output.log --alsologtostderr /opt/k3s/log/err.log
```