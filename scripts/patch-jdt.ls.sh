#!/bin/bash
declare -a FILE_PATTERNS=(".*/org\.eclipse\.jdt\.core_.*\.jar" ".*/org\.eclipse\.jdt\.core.\manipulation_.*\.jar" ".*/org\.eclipse\.jdt\.core\.compiler\.batch_.*\.jar" ".*/org\.eclipse\.jdt\.launching_.*\.jar" ".*/org\.eclipse\.jdt\.launching\.macosx_.*\.jar" ".*/org\.eclipse\.jdt\.junit\.runtime_.*\.jar" ".*/org\.eclipse\.jdt\.junit\.core_.*\.jar" ".*/org\.eclipse\.jdt\.debug_.*\.jar" ".*/org\.eclipse\.jdt\.apt\.pluggable\.core_.*\.jar" ".*/org\.eclipse\.jdt\.apt\.core_.*\.jar")

#declare -a FILE_PATTERNS=(".*/org\.eclipse\.jdt\.core_.*\.jar" ".*/org\.eclipse\.jdt\.core.\manipulation_.*\.jar" ".*/org\.eclipse\.jdt\.core\.compiler\.batch_.*\.jar" ".*/org\.eclipse\.jdt\.debug_.*\.jar")

function patch_file {
    pattern=$1
    srcDir=$2
    destDir=$3

    srcFile=$(find $srcDir -type f -regex $pattern)
    destFile=$(find $destDir -type f -regex $pattern)

    cp -f $srcFile $destFile
}

script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)

echo "## Prepair patching working dir"
mkdir $script_dir/../patch-wkdir
cd $script_dir/../patch-wkdir

if [ ! -d ./eap-site ]; then
    echo "## Clone updatesite"
    git clone https://github.com/gayanper/org.gap.eclipse.jdt.eap.git --branch gh-pages --depth 1 ./eap-site
fi

for fileregex in "${FILE_PATTERNS[@]}"
do
    echo "## Patching file $fileregex"
    patch_file "$fileregex" ./eap-site/p2/i-builds/plugins ../extensions/vscode-java/server/plugins
done

cd ./../
echo "## Patching done"
