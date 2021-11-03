```bash
# 国内github镜像源
git config --global url."https://github.com.cnpmjs.org/".insteadOf https://github.com/
git config --global url."https://github.com.cnpmjs.org/".insteadOf https://git::@github.com/
git config --global url."https://github.com/".pushInsteadOf https://github.com/

# or

cat <<EOF > ~/.gitconfig
[url "https://github.com/"]
	pushInsteadOf = https://github.com/
[url "https://github.com.cnpmjs.org/"]
	insteadOf = https://git::@github.com/
[url "https://github.com.cnpmjs.org/"]
	insteadOf = https://github.com/
EOF


# 拉配置
git clone https://github.com/myvim/.vim ~/.vim

# neovim 配置文件
mkdir -p ~/.config/nvim
echo ':so $HOME/.vim/vimrc' > ~/.config/nvim/init.vim

# for windows
mkdir -p ~/AppData/Local/nvim
echo ':so $HOME/.vim/vimrc' > ~/AppData/Local/nvim/init.vim
```