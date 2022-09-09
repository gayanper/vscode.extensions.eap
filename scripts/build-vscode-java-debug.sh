#!/bin/bash

echo "## Building vscode-java-debug"
cd ./extensions/vscode-java-debug

rm -f package-lock.json

npm install && npm run build-server && vsce package

cd ./../../
echo "## Building vscode-java-debug done"
