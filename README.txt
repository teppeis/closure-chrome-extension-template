INTRODUCTION

This is a template for building a Chrome extension that I developed in the
process of porting TargetAlert (http://goo.gl/uTvUt) from Firefox to Chrome.
Using this template will enable you to develop a Chrome extension with an
efficient edit-reload-test cycle, and will produce an optimized version of your
extension that saves bytes and protects your IP. This template heavily leverages
the Closure Tools to make this possible, so you may want to familiarize yourself
with Closure by reading _Closure: The Definitive Guide_ (http://goo.gl/9heZE).

By default, this project creates an extension that modifies document.title on
every page to 'The content script was executed on this page!'. To make the
extension do something different, modify
js/chrome/ext/contentscript/contentscript.js. To change which pages the content
script runs on, modify the "matches" section in google-chrome/manifest.json (by
default, its value is "<all_urls>").

Note: Although there is no support for developing a Firefox extension using this
template right now, ultimately it should be able to include the boilerplate for
a Firefox extension in such a way that it does not disrupt the file structure
for a Chrome extension, but that is future work.

TL;DR

1) Run serve-plovr.sh
2) On chrome://extensions, choose "Load unpacked extension..." and choose the
   google-chrome directory
3) Edit js/chrome/ext/contentscript/contentscript.js,
        js/chrome/ext/options/options.soy, and
        js/chrome/ext/options/options.js
   as necessary to add the desired behavior to your extension.
   After editing these files, simply reload the page that exercises the content
   script or the options page to exercise your changes.
   
   If you change js/chrome/ext/background/background.js or any of its
   dependencies, then you must reload the extension from chrome://extensions.
4) Run build.sh to create the zip file for your extension at
   build/google-chrome-extension.zip


DEVELOPING THE EXTENSION

Note: Google maintains detailed documentation on developing Chrome extensions at
http://code.google.com/chrome/extensions/docs.html.

Generally, you develop a Chrome extension by visiting chrome://extensions in
Google Chrome, expanding the "Developer mode" link on the top right, and
clicking "Load unpacked extension...". From the file chooser that appears, you
then select a directory that contains the manifest.json file for your extension
and its associated assets. Normally, every time that you make a change to one of
the files for your extension, you must reload it in order to test it by clicking
the "Reload" link for your extension on the chrome://extensions page.

However, when using this project template, you rarely need to use the
"Reload" link on the chrome://extensions page. Instead, you refresh the page
that is running the content script (or your options page), and you will see
your changes automatically. This should be more similar to the edit-reload-test
cycle that you have hopefully grown accustomed to when doing web development.

A tool named plovr (http://code.google.com/p/plovr/) is what is responsible for
making this edit-reload-test cycle possible. plovr is a Closure build tool, so
it leverages the Closure Compiler, Closure Library, and Closure Templates. All
of these tools are already set up for you when you use this project template.

To start developing and modifying the extension, start by running the
serve-plovr.sh script in the root directory. This will launch plovr.
When using this script, plovr is exposed as a web server, so you can see the
build targets that plovr has loaded by visiting http://localhost:2012/.

Once plovr is running, go to chrome://extensions and load an unpacked extension
as described above. When the file chooser appears, select the google-chrome
directory in this project. You should now see the following entry on the
chrome://extensions page:

TODO: Extension Name - Version: 0.1 (Unpacked)

Now go to any web site, such as http://google.com/. Instead of the normal title
of the page ("Google"), you should see "The content script was executed on this
page!" in the titlebar. This demonstrates that the extension has been loaded
successfully. As mentioned in the previous section, you should modify
js/chrome/ext/contentscript/contentscript.js to change the behavior of your
extension.

Return to the entry for your extension on chrome://extensions. There, you should
see a link to "Options". If you click on it, you should see a page that simply
displays the text "Hello world!". You should customize this page so a user can
configure any options associated with your extension. The next section explains
how to change the behavior of the options page.


CUSTOMIZING THE EXTENSION

The first thing that you should do is modify the "name" and "description" values
for your extension in google-chrome/manifest.json. Depending on the needs of
your extension, you may want to modify other values in manifest.json, as well.
See http://code.google.com/chrome/extensions/manifest.html for details on
what can be configured.

The one special line in manifest.json that you must not modify is:

  "permissions": ["http://localhost/"],

This is required so that your extension can talk to plovr while you are
developing it. The release version of your extension will not need to talk to
plovr, so this line will be stripped from manifest.json as part of the release
process.

Next, if you look at the JS and Soy files that are used for your extension, you
will notice that they use the namespace "ext". If you want to use a different
namespace for your project, you are better of editing it now before you create a
number of new files that refer to things in the "ext" namespace.

If your extension uses an options page, then you should modify the .content
template in js/chrome/ext/options/options.soy so that it produces the desired
HTML when the options page is loaded. To add behavior to the options page,
modify js/chrome/ext/options/options.js.

If your extension does not want to offer an options page, then you should
remove the following line from manifest.json:

  "options_page": "options.html",
  
You can always add it back in later if you decide to include an options page.


WHAT HAPPENS DURING DEVELOPMENT

When you load a page that exercises your content script, it makes a request to
the background page (see google-chrome/contentscript.js) which proxies a
request to http://localhost:2012/compile?id=chrome-contentscript&mode=SIMPLE&pretty-print=true.
This forces plovr to recompile your JavaScript and return the result.
The content script receives the compiled JavaScript from plovr and evaulates it.
Any JavaScript errors found by plovr will be inserted at the top of your web
page.

Similarly, the options.html page contains a <script> tag that points to
http://localhost:2012/compile?id=chrome-options&mode=SIMPLE&pretty-print=true.
Again, plovr dynamically recompiles your JavaScript, as well as your Closure
Template (options.soy). Because the default implementation of options.js
writes the .content template from options.soy into your options page, this
makes it possible to iteratively develop the options page without reloading the
extension.


RELOADING YOUR EXTENSION ON chrome://extensions PAGE

Most reloading is taken care of by plovr, so you will rarely need to reload your
extension from the chrome://extensions page. However, if you modify
js/chrome/ext/background/background.js or any of its dependencies, then you
must reload the extension via chrome://extensions. As explained on 
http://code.google.com/chrome/extensions/background_pages.html, a background
page is used "to have a single long-running script to manage some task or
state," so it is launched once when the extension starts and therefore any
changes to it will not be observed unless the extension is restarted.


STATIC RESOURCES

If your extension needs static resources, such as images or CSS files, add them
to the google-chrome directory. You will have to reload your extension via
chrome://extensions to pick up the new resources. These resources will
automatically be included in the release version of the extension.


CREATING A RELEASE

To create a release, run the build.sh script in the root directory. This will
produce a zip file in build/google-chrome-extension.zip. You can upload this
zip file to your Developer Dashboard
(https://chrome.google.com/webstore/developer/dashboard) in order to distribute
your extension.


TESTING A RELEASE

When you create a release, it creates the packaged zip file as noted above, but
it also creates an unpacked version of the extension at build/google-chrome.
You can load this directory as an unpacked extension on chrome://extensions just
as you did for the "raw" version of the extension. It is a good idea to test
this version of your extension before uploading it to the Developer Dashboard,
as this version contains the compiled version of your extension, which may
behave differently than the development version if you have violated any of the
requirements for the Advanced mode of the Closure Compiler:
http://code.google.com/closure/compiler/docs/api-tutorial3.html#dangers

Note: If you do not want to use the Advanced mode of the Closure Compiler for
the release version of your extension, edit the following line in
js/root-config.js from:

  "mode": "ADVANCED",

to

  "mode": "SIMPLE",

This is a plovr config file, which you can learn more about at
http://plovr.com/options.html.
