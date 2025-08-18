### EasyTier(Linux only)

#### 命令启动
环境变量参考[env.example](./env.example)
```shell
docker run -d --name easytier --restart always --privileged --hostname "$HOSTNAME" --network host -e TZ=Asia/Shanghai easytier/easytier:latest $COMMAND
```
#### 配置文件启动
配置文件参考[config.toml.example](./config.toml.example)
```shell
docker run -d --name easytier --restart always --privileged --hostname "$HOSTNAME" --network host -e TZ=Asia/Shanghai -v $PWD/conf:/etc/easytier easytier/easytier:latest -c /etc/easytier/config.toml
```
#### 查看所有主机
```shell
docker exec -it easytier easytier-cli peer
```

#### compose启动
```shell
vi .env # 参考 env.example
docker compose up -d

# 查看所有主机
docker compose exec easytier easytier-cli peer
```