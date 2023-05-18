#!/bin/bash

echo "## Building vscode-gradle"
cd ./extensions/vscode-gradle

rm -f ./extension/package-lock.json

version=$(grep version -m1 ./extension/package.json | sed 's/.*"version": "\(.*\)".*/\1/')
current_version=$version
new_version="${version%.*}.$(date +%y%m%d%H%M%S)"

# MacOS 
# sed -i '' "s/${current_version}/${new_version}/" "package.json"

# Linux
sed -i "s/$current_version/$new_version/g" "./extension/package.json"

./gradlew build -x test && vsce package

cd ./../../
echo "## Building vscode-gradle done"
