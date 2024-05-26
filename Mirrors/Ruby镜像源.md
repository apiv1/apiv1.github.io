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
~/.rvm/bin/rvm-installer
```