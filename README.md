# JPEG Optimizer Lightroom Plugin
This Lightroom plugin combines the following awesome tools in a post-process action:
* [exiv2](http://www.exiv2.org/)
* [ImageMagick](https://www.imagemagick.org/)
* [jpeg-archive](https://github.com/danielgtaylor/jpeg-archive/)
* [mozjpeg](https://github.com/mozilla/mozjpeg/)

It allows you to either losslessly squeeze out a few kilobytes from the JPEGs Lightroom generates, or it can take over the JPEG encoding completely and automatically set the optimal JPEG compression by measuring the perceived visual quality.

## Download
You can download the latest release from [here](https://github.com/ftischhauser/JPEGOptimizer/releases).

## Installation
* Extract the folder "JPEGOptimizer.lrplugin" from the ZIP file to "%APPDATA%\Adobe\Lightroom\Modules" or any other location. Go to File Menu / Plug-in Manager / Add and then browse the folder location and add the 'JPEGOptimizer.lrplugin' folder.
* After that you should see a new post process action in the export dialog and the publish service settings:  
  ![Post-Process Actions:](http://ftischhauser-github.s3.amazonaws.com/ftjo-ss-ppa-2.0.0.1.png)
* Select the action and click on insert:  
  ![JPEG Optimizer](http://ftischhauser-github.s3.amazonaws.com/ftjo-ss-jpo-2.0.0.1.png)

## Options

### Remove EXIF thumbnail
Lightroom generates a small thumbnail that takes up 10-20kb space and is rarely used when publishing images on the web. However some desktop and mobile apps (like [FileBrowser](http://www.stratospherix.com/products/filebrowser/)) use them to quickly draw thumbnails without decoding the full images.

### Strip ALL metadata (including thumbnail)
Completely removes all metadata from the image. Also handy if you want to share images anonymously.

### Progressive encoding
Besides the different display behavior during the image download, progressive JPEGs are also smaller. The best lossless optimizations are achieved with this option enabled, but the files will require more CPU to decode and can cause rare compatibility issues.

### Recompress JPEG
This option will switch to the external encoder [jpeg-archive](https://github.com/danielgtaylor/jpeg-archive/) and not use Lightroom for JPEG encoding anymore. As a result, the Lightroom File Settings (such as JPEG quality or file size limit) will be ingored. Instead it will force Lightroom to export a temporary TIFF file to prevent double-compression and achieve maximum quality. Keep the image format set to JPEG, the quality value will be ignored.

#### Chroma subsampling
Subsampling reduces the resolution of the color channels which is rarely noticeably by the human eye. The Lightroom encoder enables this for all quality settings below 54, jpeg-archive allows you to manually choose this for all quality levels.

#### Quality
Instead of a fixed bitrate setting, you have to choose a visual target quality. The encoder will then attempt multiple compression settings and evaluate the perceived visual quality (using one of the methods below). This will result in the smallest possible file that still looks great using a process very similar to [JPEGmini](http://www.jpegmini.com/).

#### Method
These are the different algorithms you can choose to do the image analysis. You can get more details from [jpeg-archive](https://github.com/danielgtaylor/jpeg-archive/), but I would generally recommend to use either SmallFry or SSIM.
