#!/bin/bash

echo "## Building vscode-java-test"
cd ./extensions/vscode-java-test

npm install && npm run build-plugin && vsce package

cd ./../../
echo "## Building vscode-java-test done"
