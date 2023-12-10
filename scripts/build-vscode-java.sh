#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building vscode-java"
cd ./extensions/vscode-java

rm -f package-lock.json

# absolute path to the jdt.ls folder
p2_path=$script_dir"/../jdt-repo-releng/repository/target/repository"
target_file=$script_dir"/../target-files/org.eclipse.jdt.ls.tp.target"
p2_path=$(cd -- "$p2_path" >/dev/null 2>&1 ; pwd -P)

patch_target_file $target_file "JDT_P2" $p2_path

cp $target_file ./extensions/eclipse.jdt.ls/org.eclipse.jdt.ls.target/org.eclipse.jdt.ls.tp.target && \
npm install && npm run build-server && ./../../scripts/patch-jdt.ls.sh \
&& npx gulp prepare_pre_release && npx gulp download_lombok && \
npx gulp download_jre --target darwin-arm64 --javaVersion 17 \
&& vsce package

cd ./../../
echo "## Building vscode-java done"
