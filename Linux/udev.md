# udev 速查

#### 是否支持

```sh
command -v udevadm
```

#### 网卡常用最小模板

`/etc/udev/rules.d/99-netif.rules`

```sh
ACTION=="add|remove", SUBSYSTEM=="net", KERNEL=="en*|eth*|wl*", RUN+="/usr/local/bin/netif_callback.sh %k %E{ACTION} %E{SUBSYSTEM}"
```

#### 通用规则模板（可删减）

同上路径。

```sh
ACTION=="add|remove|change|move|bind|unbind|online|offline", SUBSYSTEM=="net|usb|block|tty|input|sound|drm", KERNEL=="eth*|en*|wl*|wwan*|usb*", RUN+="/usr/local/bin/netif_callback.sh %k %E{ACTION} %s{SUBSYSTEM}"
```

#### `netif_callback.sh` 模板

```sh
#!/bin/sh
set -eu

# $1: IFACE (如 enp3s0)
# $2: ACTION (add/remove/change...)
# $3: SUBSYSTEM (可选，如 net)
IFACE="${1:-unknown}"
ACTION="${2:-unknown}"
SUBSYSTEM="${3:-unknown}"

LOG_FILE="/var/log/netif_callback.log"

log() {
  printf '%s iface=%s action=%s subsystem=%s msg=%s\n' \
    "$(date '+%F %T')" "$IFACE" "$ACTION" "$SUBSYSTEM" "$1" >> "$LOG_FILE"
}

on_add() {
  log "device added"
  # TODO: 写你的逻辑
}

on_remove() {
  log "device removed"
  # TODO: 写你的逻辑
}

on_change() {
  log "device changed"
  # TODO: 写你的逻辑
}

case "$ACTION" in
  add) on_add ;;
  remove) on_remove ;;
  change) on_change ;;
  *) log "ignored action" ;;
esac
```

脚本需 `chmod +x`。

#### 生效与调试

```sh
udevadm control --reload-rules && udevadm trigger
```

实时打印事件与环境变量，确认规则是否命中、`ACTION`/`SUBSYSTEM`/`KERNEL` 实际值：

```sh
udevadm monitor --env
```

过滤示例：`udevadm monitor --udev --subsystem-match=net`

规则语法错、`RUN` 失败等看 udev 日志：

```sh
journalctl -u systemd-udevd -e
```

实时跟：`journalctl -u systemd-udevd -f`

#### 匹配键含义 + 写法

- `ACTION`：事件动作。`ACTION=="add|remove|change"`
- `SUBSYSTEM`：设备功能分组（子系统）。`SUBSYSTEM=="net|usb|block"`
- `KERNEL`：内核设备名模式。`KERNEL=="en*|eth*|wl*"`
- `DRIVER`：驱动名。`DRIVER=="e1000e|r8169"`
- `DEVPATH`：sysfs 设备路径。`DEVPATH=="/devices/*/net/*"`
- `ENV{key}`：udev 环境变量。`ENV{ID_NET_DRIVER}=="e1000e"`
- `ATTR{key}`：当前设备 sysfs 属性。`ATTR{carrier}=="1"`
- `ATTRS{key}`：父设备链 sysfs 属性。`ATTRS{vendor}=="0x8086"`
- `TAG`：匹配已有标签。`TAG=="systemd"`

#### RUN 里常用传参变量

- `%k`：内核设备名（如 `enp3s0`）
- `%n`：设备序号
- `%p`：设备 devpath
- `%b`：父设备名
- `%M`：主设备号（major）
- `%m`：次设备号（minor）
- `%E{key}`：udev 环境变量（如 `%E{ACTION}`）
- `%s{key}`：sysfs 属性（如 `%s{carrier}`）
- `%c{N}`：`PROGRAM` 输出的第 N 段（空白分隔）

#### 常用赋值/动作键

- `RUN+="..."` `ENV{key}="value"` `TAG+="name"` `SYMLINK+="name"` `NAME="newname"`
- 操作符：`==` `!=` `=` `+=` `:=`

#### 名称说明

- `KERNEL`：历史命名，表示“内核给的设备名/模式”，不是 kernel 本体。
- `SUBSYSTEM`：内核设备模型中的功能分组，所以叫子系统。
