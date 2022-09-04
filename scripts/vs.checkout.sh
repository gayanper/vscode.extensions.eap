#!/bin/bash
repo="https://github.com/microsoft/vscode.git"
dir="vscode"

git clone $repo $dir && git -C $2 checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
