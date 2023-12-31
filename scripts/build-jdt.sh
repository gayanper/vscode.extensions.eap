#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building JDT"
cd ./extensions/

mvn -f ./jdt.core/ verify -Pbuild-individual-bundles -DskipTests && \
    mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
    mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
    mvn -f ../jdt-repo-releng/pom.xml clean verify

cd ./../
echo "## Building JDT done"
