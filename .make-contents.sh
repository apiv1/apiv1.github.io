#!/bin/sh

set -e

handle() {
  IFS=''
  while read line
  do
    PREFIX="${line%%.*}"
    PREFIX="${PREFIX//[├│]/|}"
    PREFIX="${PREFIX//[└]/+}"
    PREFIX="${PREFIX//└/+}"
    PREFIX="${PREFIX//\ /&nbsp;}"
    PREFIX="${PREFIX//─/-}"
    URL=".${line#*.}"
    URL="${URL// /\%20}"
    NAME="${line##*/}"
    [ "$NAME" = '.' ] && NAME='/'
    LINK="[$NAME]($URL)"
    echo "$PREFIX$LINK  "
  done
}

CONTENT_FILE=README.md
echo '# Contents' > "$CONTENT_FILE"
(tree --gitignore -f --noreport | handle) >> "$CONTENT_FILE"
if test -n "$(git status -s "$CONTENT_FILE")"; then
  echo '[HOOK]' \'"$CONTENT_FILE"\' updated, please commit again
  git status
  exit 1
fi