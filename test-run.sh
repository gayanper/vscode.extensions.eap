#!/bin/bash

if [[ "$1" == "--checkout" ]]; then
    if [ -d ./extensions ]; then
        rm -Rf ./extensions
    fi
    mkdir ./extensions

    echo "## Checkout Phase"
    ./scripts/checkout-modules.sh
    echo "## Patch Phase"
    ./scripts/merge-prs.sh
fi

echo "## Build Phase"
./scripts/build-jdt.sh && \
    ./scripts/build-vscode-java.sh