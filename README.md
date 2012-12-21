# JPEG Optimizer Lightroom Plugin
This plugin combines [jpegtran](http://www.ijg.org/) and [exiv2](http://www.exiv2.org/) in a post-process action to squeeze out a few kilobytes from your JPEGs without affecting the image data. It can be used during exports and with publish services.  
__Only Windows is supported at the moment!__ If you want to help by compiling and statically linking the necessary tools for distribution on OS X, let me know.

## Download
You can download the latest release from [here](http://gralsburg.org/JPEGOptimizer/JPEGOptimizer-1.0.0.1.zip).

## Installation
* Extract the folder "JPEGOptimizer.lrplugin" from the ZIP file to "%APPDATA%\Adobe\Lightroom\Modules" and restart Lightroom. Alternatively you can put it anywhere else and manually load it through the plugin manager.
* After that you should see a new post process action in the export dialog and the publish service settings:  
  ![Post-Process Actions:](http://gralsburg.org/JPEGOptimizer/ftjo-ss-ppa.png)
* Select the action and click on insert:  
  ![JPEG Optimizer](http://gralsburg.org/JPEGOptimizer/ftjo-ss-jpo.png)


## Options

### Remove EXIF thumbnail
Lightroom generates a small thumbnail that takes up 10-20kb space and is rarely used when publishing images on the web. However some desktop and mobile apps (like [FileBrowser](http://www.stratospherix.com/products/filebrowser/)) use them to quickly draw thumbnails without decoding the full images.

### Strip ALL metadata (including thumbnail)
Completely removes all metadata from the image. Might also be handy for the paranoid.

### Optimize Huffman table
JPEG uses a lossless data compression called Huffman. Lightroom isn't using the most effective encoder, so this option can save 2%-10% space without losing any quality.

### Convert to progressive JPEG
Beside the difference in the way the image is displayed during the download, progressive JPEGs are also slightly smaller (when using Huffman coding). They can cause compatibility issues though, for example the iOS photo app doesn't like progressive JPEGs in the camera roll (they load a LOT slower).

### Use arithmetic coding instead of Huffman
__You should not use this option!__ Arithmetic coding is more efficient than Huffman, but decoding support is not required by the JPEG standard. Due to patent issues this features was never widely implemented. Since those patents have now expired, the JPEG libraries and tools are slowly adding support for it. Consider this option purely experimental for now. If you want to give it a try anyway, [IrfanView](http://www.irfanview.com/) can decode them.
