# simple_placeholder_images
A bash script to fetch placeholder images of the dimensions you specify.

## Contents
 1. [About](#1-about)
 2. [License](#2-license)
 3. [Prerequisites](#3-prerequisites)
 4. [How to use](#4-how-to-use)

## 1. About

I found [spaceholder](https://github.com/ecrmnn/spaceholder) to fetch
random public domain images, but it required npm, which seemed overkill
for something this simple.

I originally intended this to create "fake" album covers instead of a stock
background, but I realize that this could be used as the base for
something like Buffer's [Pablo](http://pablo.buffer.com/) service with a 
little ImgMagick help.

## 2. License

This project is licensed under the MIT license. For the full license, see `LICENSE`.

## 3. Prerequisites

 * curl - Can be found in the `curl` package on major Linux distributions.
 * wget (for photosum) - Can be found in the `wget` package on major Linux distributions.

## 4. How to use

Usage is `imgholder.sh` with the following *optional* arguments  

 * -x [#]  X resolution of the resulting image (default 512)  
 * -y [#]  Y resolution of the resulting image (default 512)  
 * -p [placeimg|lorempixel|photosum|unsplash] Source of image (default photosum)  
 * -o [path/filename] Complete path of output, defaults to output.jpg  
 * -c [category] Category of image (placeimg and lorempixel only)  


Download an image that is 1024x1024, from unsplash  
  `imgholder.sh -p unsplash -x 1024 -y 1024`

Download an image from placeimg that is of the nature category that's 512x512  
  `imgholder -p placeimg -c nature`
