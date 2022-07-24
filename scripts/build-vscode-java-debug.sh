#!/bin/bash

echo "## Building vscode-java-debug"
cd ./extensions/vscode-java-debug

npm install && npm run build-server && vsce package

cd ./../../
echo "## Building vscode-java-debug done"
