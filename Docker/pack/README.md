### 利用Docker仓库来打包转储文件

##### 打包
```bash
# PACK_IMAGE: 镜像名
# PWD: 待打包文件夹
docker rm pack-container
docker run -it --name pack-container -v $PWD:/upload --entrypoint sh alpine -c 'cp -R /upload /pack'
docker stop pack-container
docker commit pack-container ${PACK_IMAGE}
docker rm pack-container
docker push ${PACK_IMAGE} # 推送

# 解包
docker run --rm -v $PWD:/download --entrypoint sh ${PACK_IMAGE} -c 'cp -R /pack/* /download'
```

##### 打包到httpserver
```bash
# PACK_IMAGE: 镜像名
# PWD: 待打包文件夹
# HTTP_SERVER_IMAGE: 构建自 <project>/Go/httpserver
docker rm pack-container
docker run -it --name pack-container -v $PWD:/upload --entrypoint sh ${HTTP_SERVER_IMAGE} -c 'cp -R /upload /pack'
docker stop pack-container
docker commit pack-container ${PACK_IMAGE}
docker rm pack-container
docker push ${PACK_IMAGE} # 推送

# 运行httpserver
docker run -d --rm -p 8088:8088 --entrypoint httpserver ${PACK_IMAGE} /pack
```