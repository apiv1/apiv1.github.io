### 多用户配置

#### 使用 user.conf 配置文件

1. **创建 `.env` 文件**（从 `env.example` 复制）：
   ```bash
   cp env.example .env
   ```

2. **配置 `USER_CONF` 变量**：
   ```bash
   USER_CONF='
   #username:UID:groupname:GID:password:homedir
   # 注意：注释行会被忽略，但建议保留格式说明
   # 每行一个用户，格式：用户名:UID:组名:GID:密码:家目录（可选）
   samba:1000:smb:1000:secret
   user1:1001:smb:1000:password1
   user2:1002:smb:1000:password2
   '
   ```

3. **配置 `SMB_CONF` 变量**：
   - 在共享配置中使用 `valid users` 指定允许访问的用户
   - 示例：`valid users = samba, user1, user2` 或 `valid users = @smb`（组）

4. **启动服务**：
   ```bash
   docker compose up -d
   ```

5. **验证配置是否生效**：
   ```bash
   # 检查容器内的配置文件内容
   docker compose exec samba cat /etc/samba/user.conf
   
   # 检查 Samba 配置
   docker compose exec samba testparm
   
   # 查看容器日志
   docker compose logs samba
   ```

#### user.conf 格式说明

- **格式**：`用户名:UID:组名:GID:密码:家目录（可选）`
- **每行一个用户**，不能有空行（除了注释行）
- **注释行**：以 `#` 开头的行为注释，会被忽略
- **示例**：
  ```
  samba:1000:smb:1000:secret
  user1:1001:smb:1000:password1:/home/user1
  ```

#### 常见问题

1. **user.conf 不生效**：
   - 检查 `.env` 文件中的 `USER_CONF` 变量是否正确设置
   - 检查容器内文件：`docker compose exec samba cat /etc/samba/user.conf`
   - 确保格式正确，每行一个用户，没有多余的空行
   - 确保 `smb.conf` 中的 `valid users` 包含了配置的用户名

2. **登录失败**：
   - 检查用户名和密码是否正确
   - 检查 `smb.conf` 中的 `valid users` 是否包含该用户
   - 查看容器日志：`docker compose logs samba`

### Linux挂载SMB

安装
```shell
sudo apt-get install cifs-utils
```

挂载
```shell
sudo mount -t cifs //server/share /mnt/smb -o username=user,password=pass
```

```/etc/fstab```自动挂载
```
//server/share /mnt/smb cifs username=user,password=pass 0 0

//server/share /mnt/smb cifs username=user,password=pass,gid=id,uid=id 0 0 # 给权限
```