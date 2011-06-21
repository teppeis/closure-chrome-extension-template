#!/bin/bash

# Abort if any individual command fails.
set -e

# Ensure this is run from the root directory.
cd `hg root`

# Clean out the previous build.
BUILD_DIR=build
rm -rf ${BUILD_DIR}

# Create build directories.
mkdir -p ${BUILD_DIR}
GOOGLE_CHROME_BUILD_DIR=${BUILD_DIR}/google-chrome
mkdir -p ${GOOGLE_CHROME_BUILD_DIR}

# Add static content
cp -r google-chrome/* ${GOOGLE_CHROME_BUILD_DIR}

# Scrub "permissions" section from manifest.json.
sed -i -e '/"permissions"/d' ${GOOGLE_CHROME_BUILD_DIR}/manifest.json

# Compile JavaScript
java -jar js/plovr.jar build js/chrome-contentscript-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/contentscript.js
java -jar js/plovr.jar build js/chrome-options-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/options.js
java -jar js/plovr.jar build js/chrome-background-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/background.js

# Substitute <script> tags to plovr with <script> tags to packaged JavaScript.
cp google-chrome/background.html ${GOOGLE_CHROME_BUILD_DIR}
sed -i -e 's/<script.*script>/<script src="background.js"><\/script>/g' \
    ${GOOGLE_CHROME_BUILD_DIR}/background.html
cp google-chrome/options.html ${GOOGLE_CHROME_BUILD_DIR}
sed -i -e 's/<script.*script>/<script src="options.js"><\/script>/g' \
    ${GOOGLE_CHROME_BUILD_DIR}/options.html

# Package the Chrome extension as a ZIP file.
pushd ${GOOGLE_CHROME_BUILD_DIR}
zip -r ../google-chrome-extension.zip .
popd
