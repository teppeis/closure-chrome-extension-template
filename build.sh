#!/bin/bash

# Abort if any individual command fails.
set -e

# Get the base directory.
BASE_DIR=$(cd $(dirname $0);pwd)

# Clean out the previous build.
BUILD_DIR=${BASE_DIR}/build
rm -rf ${BUILD_DIR}

# Create build directories.
mkdir -p ${BUILD_DIR}
GOOGLE_CHROME_BUILD_DIR=${BUILD_DIR}/google-chrome
mkdir -p ${GOOGLE_CHROME_BUILD_DIR}

# Add static content
CHROME_DIR=${BASE_DIR}/google-chrome
cp -r ${CHROME_DIR}/* ${GOOGLE_CHROME_BUILD_DIR}

# Scrub "permissions" section from manifest.json.
sed -i '' -e '/"permissions"/d' ${GOOGLE_CHROME_BUILD_DIR}/manifest.json

# Compile JavaScript
JS_DIR=${BASE_DIR}/js
java -jar ${JS_DIR}/plovr.jar build ${JS_DIR}/chrome-contentscript-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/contentscript.js
java -jar ${JS_DIR}/plovr.jar build ${JS_DIR}/chrome-options-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/options.js
java -jar ${JS_DIR}/plovr.jar build ${JS_DIR}/chrome-background-config.js > \
    ${GOOGLE_CHROME_BUILD_DIR}/background.js

# Substitute <script> tags to plovr with <script> tags to packaged JavaScript.
cp ${CHROME_DIR}/background.html ${GOOGLE_CHROME_BUILD_DIR}
sed -i '' -e 's/<script.*script>/<script src="background.js"><\/script>/g' \
    ${GOOGLE_CHROME_BUILD_DIR}/background.html
cp ${CHROME_DIR}/options.html ${GOOGLE_CHROME_BUILD_DIR}
sed -i '' -e 's/<script.*script>/<script src="options.js"><\/script>/g' \
    ${GOOGLE_CHROME_BUILD_DIR}/options.html

# Package the Chrome extension as a ZIP file.
pushd ${GOOGLE_CHROME_BUILD_DIR}
zip -r ../google-chrome-extension.zip .
popd
