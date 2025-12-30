#!/bin/bash

set -e

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)/..";pwd)
cd $SCRIPT_HOME

type tree > /dev/null 2>&1 || (echo 'please install `tree`'; exit 1)

handle() {
  IFS=''
  while read line
  do
    PREFIX="${line%%.*}"
    # 统一替换 tree 输出的字符，确保跨平台一致性
    # 处理 Unicode 字符（Mac/Linux 默认输出）
    PREFIX="${PREFIX//├/|}"
    PREFIX="${PREFIX//│/|}"
    PREFIX="${PREFIX//└/+}"
    PREFIX="${PREFIX//─/-}"
    # 处理 ASCII 字符（使用 --charset ascii 时的输出，反引号需要转义）
    PREFIX="${PREFIX//\`/+}"
    # 将空格替换为 &nbsp;
    PREFIX="$(echo "$PREFIX" | sed 's/ /\&nbsp;/g')"
    URL=".${line#*.}"
    URL="${URL// /%20}"
    NAME="${line##*/}"
    [ "$NAME" = '.' ] && NAME='/'
    LINK="[$NAME]($URL)"
    echo "$PREFIX$LINK  "
  done
}

# 统一使用 UTF-8 编码，确保跨平台一致性
# 优先使用 C.UTF-8 或 en_US.UTF-8，避免不同系统的 locale 差异
if locale -a 2>/dev/null | grep -q "C.UTF-8"; then
  export LC_ALL=C.UTF-8 LANG=C.UTF-8
elif locale -a 2>/dev/null | grep -q "en_US.UTF-8"; then
  export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
elif test -n "$(locale -a 2>/dev/null | grep zh_CN)"; then
  export LC_ALL=zh_CN.UTF-8 LANG=zh_CN.UTF-8
else
  export LC_ALL=C.UTF-8 LANG=C.UTF-8
fi

CONTENT_FILE=README.md
echo '# Contents' > "$CONTENT_FILE"

# 使用 --charset UTF-8 确保跨平台输出一致
# 如果 tree 支持 --charset，使用 UTF-8 来确保 Unicode 字符正确处理
if tree --help 2>&1 | grep -q "charset"; then
  (tree --charset UTF-8 --sort name -v -f --noreport | handle) >> "$CONTENT_FILE"
else
  # 否则使用标准选项，但确保编码一致
  (tree --sort name -v -f --noreport | handle) >> "$CONTENT_FILE"
fi