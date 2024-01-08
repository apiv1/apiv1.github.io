#!/bin/bash

set -e

CONTENT_FILE=README.md
if test -n "$(git status -s "$CONTENT_FILE")"; then
  echo '[HOOK]' \'"$CONTENT_FILE"\' updated, please commit again
  git status
  exit 1
fi