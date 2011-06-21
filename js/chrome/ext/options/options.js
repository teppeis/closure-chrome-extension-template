/**
 * @fileoverview This is responsible for writing the HTML and handling events on
 * the Options page for this extension.
 *
 * @see http://code.google.com/chrome/extensions/options.html
 */
goog.provide('ext.options');

goog.require('ext.templates.options');

goog.require('goog.dom');
goog.require('soy');


/**
 * Insertion point for the page.
 */
ext.options.main = function() {
  soy.renderElement(
      goog.dom.getElement('content'),
      ext.templates.options.content);
};


ext.options.main();
