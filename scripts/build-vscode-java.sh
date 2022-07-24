#!/bin/bash

cd ./extensions/vscode-java

cp -f ../../target-files/org.eclipse.jdt.ls.tp.target ../eclipse.jdt.ls/org.eclipse.jdt.ls.target && \
npm run build-server && vsce package

#npm install &&

cd ./../../