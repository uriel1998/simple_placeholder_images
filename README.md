# A bash script to fetch placeholder images of the dimensions you specify.

I found [spaceholder](https://github.com/ecrmnn/spaceholder) to fetch
random public domain images, but it required npm, which seemed overkill
for something this simple.

I'm intending this to create "fake" album covers instead of a stock
background, but I realize that this could be used as the base for
something like Buffer's *Pablo* service with a little Imgmagick help.

## Requires

* curl

## Usage

-O  (jpg format)

http://lorempixel.com/640/640/nature
http://lorempixel.com/640/640/abstract

https://unsplash.it/640/?random
https://unsplash.it/200/300/?blur

https://github.com/DMarby/unsplash-it


http://placeimg.com/640/640/nature
http://placeimg.com/640/640/architecture
http://placeimg.com/640/640/tech