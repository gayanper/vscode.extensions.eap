#!/bin/bash

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

version=$(grep version -m1 package.json | sed 's/.*"version": "\(.*\)".*/\1/')
current_version=$version
new_version="${version%.*}.$(date +%y%m%d%H%M%S)"

# MacOS 
# sed -i '' "s/${current_version}/${new_version}/" "package.json"

# Linux
sed -i 's/"${current_version}"/"${new_version}/g' "package.json"


npm install && npm run build-server && ./../../scripts/patch-jdt.ls.sh \
&& npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package

cd ./../../
echo "## Building vscode-java done"
