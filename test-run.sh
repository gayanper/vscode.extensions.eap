#!/bin/bash

if [ -z $1 ]; then
    echo "Specify either --checkout or --only-checkout"
    exit 1
fi

suffix="$2"

if [[ "$1" == "--checkout" || "$1" == "--only-checkout" ]]; then
    if [ -d ./extensions ]; then
        rm -Rf ./extensions
    fi
    mkdir ./extensions

    echo "## Checkout Phase"
    ./scripts/checkout-modules.sh
    echo "## Patch Phase"
    ./scripts/merge-prs.sh true $suffix
fi

if [[ "$1" != "--only-checkout" ]]; then
    echo "## Build Phase"
    ./scripts/build-jdt.sh && \
        ./scripts/patch-p2-repo.sh && \
        ./scripts/build-vscode-java.sh
fi