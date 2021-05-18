···
cat <<EOF > ~/.tmux.conf
set -g default-terminal "xterm-256color"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
EOF
···
配色使用xterm-256
分屏保留路径
