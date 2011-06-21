/**
 * @fileoverview This is the singleton, long-running script that an extension
 * can run.
 *
 * @see http://code.google.com/chrome/extensions/background_pages.html 
 */
goog.provide('ext.background');

goog.require('goog.net.XhrIo');


/**
 * @param {function(*)} sendResponse Takes an argument that can be serialized as
 *     JSON.
 */
ext.background.proxyContentScript = function(sendResponse) {
  var url = 'http://localhost:2012/compile?' +
      'id=chrome-contentscript&mode=SIMPLE&pretty-print=true';
  goog.net.XhrIo.send(url, function(e) {
    var xhr = /** @type {goog.net.XhrIo} */ (e.target);
    sendResponse(xhr.getResponseText());
  });
};


/**
 * @param {Object} request JSON sent by sender.
 * @param {MessageSender} sender has a 'tab' property if sent from a content
 *     script.
 * @param {function(*)} sendResponse Call this to send a response to the
 *     request (which must be JSON).
 */
ext.background.onRequest = function(request, sender, sendResponse) {
  if (request['proxyContentScript'] == true) {
    ext.background.proxyContentScript(sendResponse);
  }
};


chrome.extension.onRequest.addListener(ext.background.onRequest);


// Workaround for failing to include deps.js.
// See http://code.google.com/p/closure-library/issues/detail?id=340
goog.addDependency('/dev/null', ['goog.Uri'], []);
goog.addDependency('/dev/null', ['goog.debug.ErrorHandler'], []);
goog.addDependency('/dev/null', ['goog.events.EventTarget'], []);
goog.addDependency('/dev/null', ['goog.events.EventHandler'], []);
