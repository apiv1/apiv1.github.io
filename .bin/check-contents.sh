#!/bin/sh

set -e

SCRIPT_HOME=$(cd "$(dirname "$0" 2>/dev/null)/..";pwd)
cd $SCRIPT_HOME

CONTENT_FILE=README.md
if test -n "$(git status -s "$CONTENT_FILE")"; then
  echo '[HOOK]' \'"$CONTENT_FILE"\' updated, please commit again
  git status
  exit 1
fi