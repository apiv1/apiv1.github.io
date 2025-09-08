```bash
# 国内github镜像源
git config --global url."https://kkgithub.com/".insteadOf https://git::@github.com/ # only for windows
git config --global url."https://kkgithub.com/".insteadOf https://github.com/
git config --global url."https://github.com/".pushInsteadOf https://github.com/

# or

cat <<EOF > ~/.gitconfig
[url "https://github.com/"]
  pushInsteadOf = https://github.com/
[url "https://kkgithub.com/"]
  insteadOf = https://git::@github.com/
[url "https://kkgithub.com/"]
  insteadOf = https://github.com/
EOF


# 拉配置
git clone https://github.com/myvim/.vim ~/.vim
# or
git clone https://github.com/myvim/.vim $HOME/.vim

# vim 配置文件
echo ':so $HOME/.vim/vimrc' > ~/.vimrc

# Windows (必须使用CMD.exe)
echo ':so $HOME/.vim/vimrc' > ~/_vimrc

# neovim 配置文件
mkdir -p ~/.config/nvim
echo ':so $HOME/.vim/vimrc' > ~/.config/nvim/init.vim

# for windows
mkdir -p ~/AppData/Local/nvim
echo ':so $HOME/.vim/vimrc' > ~/AppData/Local/nvim/init.vim

# coc.nvim 配置npm镜像
npm config set coc.nvim:registry https://registry.npmmirror.com/ # coc.nvim那个installer程序会读 ~/.npmrc, 扫描`coc.nvim:registry` 这个配置 写死成npm源. 代码非常离谱...
```