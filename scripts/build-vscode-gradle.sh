#!/bin/bash

echo "## Building vscode-gradle"
cd ./extensions/vscode-gradle

version=$(grep version -m1 ./extension/package.json | sed 's/.*"version": "\(.*\)".*/\1/')
current_version=$version
new_version="${version%.*}.$(date +%y%m%d%H%M%S)"

# MacOS 
# sed -i '' "s/${current_version}/${new_version}/" "package.json"

# Linux
sed -i "s/$current_version/$new_version/g" "./extension/package.json"

./gradlew build -x test && cd ./extension && vsce package && cd ../

cd ./../../
echo "## Building vscode-gradle done"
