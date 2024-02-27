#!/bin/bash
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

echo "## Patching P2 Repository"
# first verify to make sure the repo we just created from the upstream is valid, that is all checksums are correct
# then patch files and remove checksums again check the repo to make sure its still valid

mvn -f ./jdt-repo-releng/pom.xml org.eclipse.tycho:tycho-p2-repository-plugin:4.0.4:verify-repository && \
    /usr/bin/python3 $script_dir/patch-p2-repository.py && \
    mvn -f ./jdt-repo-releng/pom.xml org.eclipse.tycho:tycho-p2-repository-plugin:4.0.4:fix-artifacts-metadata && \
    mvn -f ./jdt-repo-releng/pom.xml org.eclipse.tycho:tycho-p2-repository-plugin:4.0.4:verify-repository

echo "## Patching P2 Repository done"


