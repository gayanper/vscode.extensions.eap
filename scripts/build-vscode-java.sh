#!/bin/bash

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

npm install && npm run build-server && ./../../scripts/patch-jdt.ls.sh && vsce package

cd ./../../
echo "## Building vscode-java done"
