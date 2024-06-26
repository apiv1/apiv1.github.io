```bash
git clone https://github.com/containers/skopeo
cd skopeo; git checkout -b v1.5.2 v1.5.2

docker run --rm -it -v $PWD:/app -w /app golang:1.17.6-bullseye

sed -i "s/deb.debian.org/ftp.cn.debian.org/g" /etc/apt/sources.list
apt-get update && apt-get install -y -qq libgpgme11-dev

GOPROXY="https://goproxy.cn,https://goproxy.io,direct" CGO_CFLAGS="" CGO_LDFLAGS="-L/usr/lib/x86_64-linux-gnu -lgpgme -lassuan -lgpg-error" GO111MODULE=on go build -mod=vendor "-buildmode=pie" -ldflags '-X main.gitCommit=8a88191c844a35cd54048c34bee3a6656ed5df5f -s -w -linkmode "external" -extldflags "-static"' -gcflags "" -tags "btrfs_noversion exclude_graphdriver_btrfs libdm_no_deferred_remove exclude_graphdriver_devicemapper containers_image_openpgp" -o bin/skopeo ./cmd/skopeo
```
or

```bash
git clone -b v1.5.2-DockerBuilder https://github.com/backrise/skopeo
cd skopeo; docker build . -t skopeo-images
```

使用skopeo
```shell
skopeo() {
  local DOCKER_SOCK=${DOCKER_HOST//unix:\/\//}
  docker run -it --rm -v ${DOCKER_SOCK:-/var/run/docker.sock}:/var/run/docker.sock quay.io/skopeo/stable $*
}
```

上传本地镜像到 hub.docker.com # 可以命令行配置代理
```shell
skopeo copy --dest-creds=$USER:$PASS --dest-tls-verify=false docker-daemon:$UPLOAD_IMAGE docker://$UPLOAD_IMAGE
```

镜像仓库之间对拷某个镜像
```shell
skopeo copy --multi-arch all --dest-creds=$USER:$PASS docker://$SRC_REGISTRY/$IMAGE_NAME docker://$DST_REGISTRY/$IMAGE_NAME
```