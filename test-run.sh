#!/bin/bash

if [[ "$1" == "--checkout" || "$1" == "--only-checkout" ]]; then
    if [ -d ./extensions ]; then
        rm -Rf ./extensions
    fi
    mkdir ./extensions

    echo "## Checkout Phase"
    ./scripts/checkout-modules.sh
    echo "## Patch Phase"
    ./scripts/merge-prs.sh true javac
fi

if [[ "$1" != "--only-checkout" ]]; then
    echo "## Build Phase"
    ./scripts/build-jdt.sh && \
        ./scripts/patch-p2-repo.sh && \
        ./scripts/build-vscode-java.sh
fi