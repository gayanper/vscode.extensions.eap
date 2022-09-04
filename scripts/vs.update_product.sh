#!/bin/bash

setpath_json "product" "extensionsGallery" '{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "itemUrl": "https://marketplace.visualstudio.com/items", "nlsBaseUrl": "https://www.vscode-unpkg.net/_lp/", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "publisherUrl": "https://marketplace.visualstudio.com/publishers", "resourceUrlTemplate": "https://{publisher}.vscode-unpkg.net/{publisher}/{name}/{version}/{path}", "controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json", "recommendationsUrl": "https://az764295.vo.msecnd.net/extensions/workspaceRecommendations.json.gz"}'

setpath "product" "quality" "insider"