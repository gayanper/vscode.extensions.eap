#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building JDT"
cd ./jdt-repo-releng

mvn install -Pbuild-individual-bundles -DskipTests

cd ./../
echo "## Building JDT done"
