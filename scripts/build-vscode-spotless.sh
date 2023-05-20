#!/bin/bash

echo "## Building vscode-spotless-gradle"
cd ./extensions/vscode-spotless-gradle

version=$(grep version -m1 package.json | sed 's/.*"version": "\(.*\)".*/\1/')
current_version=$version
new_version="${version%.*}.$(date +%y%m%d%H%M%S)"

# MacOS 
# sed -i '' "s/${current_version}/${new_version}/" "package.json"

# Linux
sed -i "s/$current_version/$new_version/g" "package.json"

npm install && npm package

cd ./../../
echo "## Building vscode-spotless-gradle done"
