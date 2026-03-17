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
[compose.yml](./compose.yml)：
- **命令方式**：在 .env 里设置 `COMMAND`（参考 [env.example](./env.example)）
- **配置文件方式**：在 .env 里设置 `CONFIG_TOML` 为完整 config.toml 内容（参考 [env.config.example](./env.config.example)）。不设 `COMMAND` 时默认用 `-c /etc/easytier/config.toml` 启动；若设置了自定义 `COMMAND`，则按 `COMMAND` 启动，`CONFIG_TOML` 不一定生效

```shell
vi .env # 按上面二选一或组合
docker compose up -d

# 查看所有主机
docker compose exec easytier easytier-cli peer
```

### 高级参数
[使用出口节点](./exit-node.md)