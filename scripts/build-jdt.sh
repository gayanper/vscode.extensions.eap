#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building JDT"
cd ./extensions/

if [[ "$USE_JAVAC_BRANCH" == "true" ]]; then
    mvn -f ./jdt.core/ install -DskipTests -Pp2-repo && \
        # mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
        # mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
        mvn -f ../jdt-repo-releng/pom.xml clean verify
else
    mvn -f ./jdt.core/ verify -Pbuild-individual-bundles -DskipTests && \
        # mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
        # mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
        mvn -f ../jdt-repo-releng/pom.xml clean verify
fi

cd ./../
echo "## Building JDT done"
