#!/bin/bash

if [ -d ./extensions ]; then
    rm -Rf ./extensions
fi
mkdir ./extensions

echo "## Checkout Phase"
./scripts/checkout-modules.sh

echo "## Patch Phase"
./scripts/merge-prs.sh

echo "## Build Phase"
./scripts/build-vscode-java.sh