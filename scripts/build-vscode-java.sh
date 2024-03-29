#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

# absolute path to the jdt.ls folder
target_file=$script_dir"/../target-files/org.eclipse.jdt.ls.tp.target"

cp -f $target_file $script_dir"/../extensions/eclipse.jdt.ls/org.eclipse.jdt.ls.target/org.eclipse.jdt.ls.tp.target" && \
npm install && npm run build-server \
&& npx gulp prepare_pre_release && npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package

cd ./../../
echo "## Building vscode-java done"
