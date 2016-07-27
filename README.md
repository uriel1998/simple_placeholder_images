# A bash script to fetch placeholder images of the dimensions you specify.

I found [spaceholder](https://github.com/ecrmnn/spaceholder) to fetch
random public domain images, but it required npm, which seemed overkill
for something this simple.

I originally intended this to create "fake" album covers instead of a stock
background, but I realize that this could be used as the base for
something like Buffer's *Pablo* service with a little ImgMagick help.

## Requires

* curl

## Usage
Usage is **imgholder.sh** with the following *optional* arguments
* -x [#]  X resolution of the resulting image (default 512)
* -y [#]  Y resolution of the resulting image (default 512)
* -p [placeimg|lorempixel|unsplash] Source of image (default unsplash)
* -o [path/filename] Complete path of output
* -b Engage blur on image (unsplash only)
* -c [category] Category of image (placeimg and lorempixel only)

### Examples

Download an image that is 1024x1024, from unsplash.it, with blur applied.
  imgholder.sh -x 1024 -y 1024 -b

Download an image from placeimg that is of the nature category that's 512x512
  imgholder -p placeimg -c nature
