```bash
# RubyGems

# ruby-china
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# tsinghua
gem sources --add http://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
bundle config mirror.https://rubygems.org http://mirrors.tuna.tsinghua.edu.cn/rubygems/

# RVM
git clone https://github.com/rvm/rvm ~/.rvm
mkdir -p ~/.rvm/user
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db

echo '
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
' > ~/.profile

# 编译出问题处理
# https://github.com/rvm/rvm/issues/5365#issuecomment-1622004810
brew install openssl@1.1
rvm install 3.3.5 --with-openssl-dir=$(brew --prefix openssl@1.1)
```