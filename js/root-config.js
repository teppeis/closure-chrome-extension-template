{
  "mode": "ADVANCED",
  "level": "VERBOSE",
  "externs": [
    "//chrome_extensions.js"
  ],
  "define": {
    "goog.DEBUG": false,
    "goog.userAgent.ASSUME_WEBKIT": true,
    "goog.userAgent.jscript.ASSUME_NO_JSCRIPT": true
  },
  "output-wrapper": "(function(){%output%})();",
  "checks": {
    // Because this code is being compiled exclusively for Chrome, there is
    // no need to warn about trailing commas in object or array literals.
    "internetExplorerChecks": "OFF",
    "checkRegExp": "ERROR",
    "checkTypes": "ERROR",
    "checkVars": "ERROR",
    "deprecated": "ERROR",
    "fileoverviewTags": "ERROR",
    "invalidCasts": "ERROR",
    "missingProperties": "ERROR",
    "nonStandardJsDocs": "ERROR",
    "undefinedVars": "ERROR",
    
    // Not every config that inherits from this config will transitively
    // include everything in the "define" section, so some defines may be
    // unknown to the Compiler. Therefore, we disable this check, but must
    // be very careful that the options in the "define" section are spelled
    // correctly.
    "unknownDefines": "OFF"
  },
  "treat-warnings-as-errors": true
}
