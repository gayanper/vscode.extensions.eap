#!/bin/bash

echo "## Building vscode-java-test"
cd ./extensions/vscode-java-test

rm -f package-lock.json

npm install && npm run build-plugin && vsce package

cd ./../../
echo "## Building vscode-java-test done"
