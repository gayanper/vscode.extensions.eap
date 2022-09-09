#!/bin/bash

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

cp -f ../../target-files/org.eclipse.jdt.ls.tp.target ../eclipse.jdt.ls/org.eclipse.jdt.ls.target && \
npm install && npm run build-server && vsce package

cd ./../../
echo "## Building vscode-java done"
