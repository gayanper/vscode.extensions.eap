#!/bin/bash
VERSION=$(echo $1 | awk -F"-" '{ print $2}' | awk -F".vsix" '{ print $1}')
echo "## Uploading $1 with the version $VERSION ##"
cloudsmith push raw gap/vsce $1 --version $VERSION --republish 