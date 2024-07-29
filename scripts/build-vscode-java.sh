#!/bin/bash
set -e
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

# if [[ "$USE_JAVAC_BRANCH" != "true" ]]; then
#     # only replace target file when building against none javac branch
#     # absolute path to the jdt.ls folder
#     target_file=$script_dir"/../target-files/org.eclipse.jdt.ls.tp.target"
#     cp -f $target_file $script_dir"/../extensions/eclipse.jdt.ls/org.eclipse.jdt.ls.target/org.eclipse.jdt.ls.tp.target"
# fi

npm install && npm run build-server \
&& npx gulp prepare_pre_release && npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package

cd ./../../
echo "## Building vscode-java done"
