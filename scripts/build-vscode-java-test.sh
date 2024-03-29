#!/bin/bash

echo "## Building vscode-java-test"
cd ./extensions/vscode-java-test

rm -f package-lock.json

version=$(grep version -m1 package.json | sed 's/.*"version": "\(.*\)".*/\1/')
current_version=$version
new_version="${version%.*}.$(date +%y%m%d%H%M%S)"

# MacOS 
#sed -i '' "s/ \"${current_version}\"/ \"${new_version}\"/" "package.json"

# Linux
sed -i "s/ \"${current_version}\"/ \"${new_version}\"/g" "package.json"

export MAVEN_OPTS="-DskipTests=true -Dtycho.plugin-test.skip=true -DskipITs=true"
npm install && npm run build-plugin && vsce package

cd ./../../
echo "## Building vscode-java-test done"
