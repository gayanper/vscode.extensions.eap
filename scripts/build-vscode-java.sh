#!/bin/bash

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

version=$(grep version -m1 package.json | sed 's/.*"version": "\(.*\)".*/\1/')
version="$version-$(date +%y%m%d_%H%M%S)"

npm install && npm run build-server && ./../../scripts/patch-jdt.ls.sh \
&& npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package -o "java-$version.vsix"

cd ./../../
echo "## Building vscode-java done"
