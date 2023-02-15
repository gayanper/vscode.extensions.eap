#!/bin/bash
VERSION=$(echo $1 | awk -F"-" '{ print $NF}' | awk -F".vsix" '{ print $1}')
TIME=$(date +%y%m%d_%H%M%S)
VERSION="$VERSION-$TIME"
echo "## Uploading $1 with the version $VERSION ##"
cloudsmith push raw gap/vsce $1 --version $VERSION --republish 