参考 [rxproxy](https://rsproxy.cn/)

#### config

$HOME/.cargo/config.toml

```ini
[source.crates-io]
replace-with = 'rsproxy'

[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"

[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"

[net]
git-fetch-with-cli = true

[registry]
default = "rsproxy"
```

#### env

bash

```shell
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
```

powershell

```powershell
$env:RUSTUP_DIST_SERVER="https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
```

#### install

rustup

```shell
# 官方安装
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 镜像安装
curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh
```

rust

```shell
rustup install stable

# 升级
rustup update
```