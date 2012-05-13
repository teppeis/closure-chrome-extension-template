#!/bin/bash

BASE_DIR=$(cd $(dirname $0);pwd)
JS_DIR=${BASE_DIR}/js

PORT=2012

java -jar ${JS_DIR}/plovr.jar serve --port ${PORT} \
    ${JS_DIR}/chrome-contentscript-config.js \
    ${JS_DIR}/chrome-background-config.js \
    ${JS_DIR}/chrome-options-config.js
