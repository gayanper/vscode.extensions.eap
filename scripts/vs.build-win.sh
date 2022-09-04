echo "## Building vscode-oss"
cd ./vscode

yarn && \
yarn gulp compile-build && \
yarn gulp compile-extension-media && \
yarn gulp compile-extensions-build && \
yarn gulp vscode-win32-x64-inno-updater && \
yarn gulp vscode-win32-x64-min && \
yarn gulp vscode-win32-x64-user-setup

cd ..