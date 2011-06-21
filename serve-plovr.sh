#!/bin/bash

cd `hg root`

PORT=2012

java -jar js/plovr.jar serve --port ${PORT} \
    js/chrome-contentscript-config.js \
    js/chrome-background-config.js \
    js/chrome-options-config.js
