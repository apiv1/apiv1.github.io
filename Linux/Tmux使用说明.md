
1. **装tmux**

```bash
sudo yum -y install tmux # centos
sudo apt install -y tmux # ubuntu
```

2. 配置直接用[tmuxrc](../Shell/tmuxrc), 配到配置文件里

~~2. 执行这个命令 生成一个脚本 放在用户目录里~~

_**.reuse_session.sh**_

```bash
cat <<EOF > ~/.reuse_session.sh
if [ ! -n "\$TMUX" ]; then
  tmux a -t "\$USER" > /dev/null
  if [ "\$?" -ne 0 ]; then
    tmux new -s "\$USER"
  fi
  exit
fi
EOF
```

~~3. 把脚本添加到登录脚本里~~

```bash
#  bash用户加 .bash_profile
echo '. ~/.reuse_session.sh' >> ~/.bash_profile

#  zsh用户加 .zprofile
echo '. ~/.reuse_session.sh' >> ~/.zprofile
```

4. ssh连上以后脚本自动给你套个tmux, 你终端的最下方会有个绿色的条(当前3.0a版本). 你如果意外断开了再连回去会话shell还是原来的, 如果想断开连接并保留会话, 就按 Ctrl+b 然后按d 他就断开了, 连接回去还是原来的shell. 你本来连着一个, 又从其他地方连上去, 两个地方就会共享一个会话, 这个就很厉害.
5. 用tmux还可以在一个会话里面开多个终端, 就不用登录多个窗口. 介绍一些用法

- Ctrl+b 是命令开始快捷键, tmux的所有命令都要跟个这个快捷键
- % 是左右分两个终端, " 是 上下分两个终端
- 多终端的时候 Ctrl + b后按着 上下左右可以换不同的终端, 按着alt(有的电脑是按着ctrl) 再按上下左右可以调整终端窗口大小
- 其他的我也不知道, 可以按Ctrl + b 然后按?看帮助

~~6. tmux配置文件~~

```bash
cat <<EOF > ~/.tmux.conf
set -g default-terminal "xterm-256color"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
set -g mouse on
EOF
```

配色使用xterm-256  
分屏保留路径  
