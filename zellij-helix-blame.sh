#!/usr/bin/env bash

set -e

tmpfile=$(mktemp)

zellij action dump-screen "$tmpfile"
PANE_OUTPUT=$(cat "$tmpfile")
rm "$tmpfile"

# Extract file and line information
RES=$(echo "$PANE_OUTPUT" | rg -e "(?:NOR|INS|SEL)\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
FILE=$(echo $RES | awk '{print $1}')
LINE=$(echo $RES | awk '{print $2}')

git_hash=$(git blame $FILE -L $LINE,$LINE -l | awk '{print $1}')

if [ -z "$git_hash" ];
then
  echo -n ""
else
  git show --stat $git_hash
fi
