#!/bin/bash

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

npm install && npm run build-server && ./../../scripts/patch-jdt.ls.sh \
&& npx gulp prepare_pre_release && npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package --pre-release

cd ./../../
echo "## Building vscode-java done"
