echo "## Building vscode-oss"
cd ./vscode

yarn && \
yarn gulp compile-build && yarn gulp compile-extension-media && yarn gulp compile-extensions-build && yarn gulp minify-vscode && \ 
yarn gulp "vscode-darwin-arm64-min-ci"

cd ..
