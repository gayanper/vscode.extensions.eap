#!/bin/bash
set -e
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Building JDT"
cd ./extensions/

if [[ "$USE_JAVAC_BRANCH" == "true" ]]; then
    mvn -f ./jdt.core/ \
        -pl '!org.eclipse.jdt.core.tests.builder,!org.eclipse.jdt.core.tests.compiler,!org.eclipse.jdt.core.tests.javac,!org.eclipse.jdt.core.tests.model,!org.eclipse.jdt.core.tests.performance,!org.eclipse.jdt.compiler.tool.tests,!org.eclipse.jdt.compiler.apt.tests,!org.eclipse.jdt.apt.ui,!org.eclipse.jdt.apt.tests,!org.eclipse.jdt.apt.pluggable.tests' \
        install -DskipTests -Pp2-repo && \
        # mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
        # mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
        mvn -f ../jdt-repo-releng/pom.xml clean verify
else
    # mvn -f ./jdt.core/ verify -Pbuild-individual-bundles -DskipTests && \
    #     # mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
    #     # mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
    #     mvn -f ../jdt-repo-releng/pom.xml clean verify

    mvn -f ./jdt.core/ \
        -pl '!org.eclipse.jdt.core.tests.builder,!org.eclipse.jdt.core.tests.compiler,!org.eclipse.jdt.core.tests.model,!org.eclipse.jdt.core.tests.performance,!org.eclipse.jdt.compiler.tool.tests,!org.eclipse.jdt.compiler.apt.tests,!org.eclipse.jdt.apt.ui,!org.eclipse.jdt.apt.tests,!org.eclipse.jdt.apt.pluggable.tests' \
        install -DskipTests -Pp2-repo && \
        # mvn -f ./jdt.debug/ verify -Pbuild-individual-bundles -DskipTests && \
        # mvn -f ./jdt.ui/ verify -Pbuild-individual-bundles -DskipTests && \
        mvn -f ../jdt-repo-releng/pom.xml clean verify
fi

cd ./../
echo "## Building JDT done"
