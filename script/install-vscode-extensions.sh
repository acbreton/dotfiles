#!/bin/bash
set -e

EXTENSIONS="$(code --list-extensions)"

for EXTENSION in $(cat $(dirname $0)/../vscode-extensions)
do
  if echo "$EXTENSIONS" | grep -q "$EXTENSION"
  then
    echo "Extension '$EXTENSION' is already installed."
  else
    code --install-extension "$EXTENSION"
  fi
done
