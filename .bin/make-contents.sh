#!/bin/bash

set -e

type tree > /dev/null 2>&1 || (echo 'please install `tree`'; exit 1)

handle() {
  IFS=''
  while read line
  do
    PREFIX="${line%%.*}"
    PREFIX="${PREFIX//[├│]/|}"
    PREFIX="${PREFIX//[└]/+}"
    PREFIX="${PREFIX//\ /&nbsp;}"
    PREFIX="${PREFIX//─/-}"
    URL=".${line#*.}"
    URL="${URL// /%20}"
    NAME="${line##*/}"
    [ "$NAME" = '.' ] && NAME='/'
    LINK="[$NAME]($URL)"
    echo "$PREFIX$LINK  "
  done
}

CONTENT_FILE=README.md
echo '# Contents' > "$CONTENT_FILE"
(tree --sort name -v -f --noreport | handle) >> "$CONTENT_FILE"