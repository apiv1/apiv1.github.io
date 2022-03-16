### 利用Docker仓库来打包转储文件


```bash
# 打包
# PACK_IMAGE: 镜像名
# PWD: 待打包文件夹
docker rm pack-container
docker run --name pack-container -v $PWD:/upload alpine cp -R /upload /pack
docker stop pack-container
docker commit pack-container ${PACK_IMAGE}
docker rm pack-container
docker push ${PACK_IMAGE} # 推送

# 解包
docker run --rm -v $PWD:/download ${PACK_IMAGE} sh -c 'cp -R /pack/* /download'
```