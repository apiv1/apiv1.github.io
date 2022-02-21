```bash
# RubyGems
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# RVM
git clone https://github.com/rvm/rvm ~/.rvm
~/.rvm/bin/rvm-installer
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db
```