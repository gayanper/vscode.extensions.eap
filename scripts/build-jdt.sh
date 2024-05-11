#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building JDT"
cd ./extensions/

if [[ "$USE_JAVAC_BRANCH" == "true" ]]; then
    git -C ./jdt.core/ pull --no-rebase --no-edit https://github.com/eclipse-jdtls/eclipse-jdt-core-incubator.git dom-with-javac
else 
    git -C ./jdt.core/ pull --no-rebase --no-edit https://github.com/eclipse-jdtls/eclipse-jdt-core-incubator.git master
fi

if [[ "$USE_JAVAC_BRANCH" == "true" ]]; then
    mvn -f ./jdt.core/ verify -DskipTests -Pp2-repo -Pbuild-individual-bundles && \
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
