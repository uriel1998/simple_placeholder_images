#!/bin/bash

########################################################################
# This script is designed to return a public domain image from online
# providers. Sane defaults are provided, but commandline options are
# available for customization.
########################################################################

########################################################################
# Declarations
########################################################################
declare -i Xpx=512
declare -i Ypx=512
declare Provider
declare Outfile
declare Category
declare Scratch

Provider="unsplash"
Outfile="$PWD/outfile.jpg"

########################################################################
# options
# -x [#]
# -y [#]
# -p [placeimg|lorempixel|unsplash|picsum]
# -o [path]
# -c [category name]
# I should probably use getopt for this
########################################################################
while [ $# -gt 0 ]; do
option="$1"
    case $option
    in
    -p) Provider="$2"
    shift
    shift ;;
    -c) Category="$2"
    shift
    shift ;;
    -x) Xpx="$2"
    shift
    shift ;;
    -y) Ypx="$2"
    shift
    shift ;;    
    -o) Outfile=$(readlink -f "$2")
    shift
    shift ;;
    esac
done

echo "$Outfile"
################################################################################
# Ensuring that either sane defaults are used, or user input is not insane.
################################################################################
check_variables(){
  declare -i craptastic=0
  case $Xpx in
      ''|*[!0-9]*) craptastic=craptastic+1 ;;
      *)  ;;
  esac
  case $Ypx in
      ''|*[!0-9]*) craptastic=craptastic+1 ;;
      *) ;;
  esac
  # I'm temporarily hardcoding the category strings in.
  case $Provider in
    unsplash) Provider="http://source.unsplash.com";Blur="";Category="";;
    placeimg) Provider="http://placeimg.com";Blur="";Category="any";;
    lorempixel) Provider="http://lorempixel.com";Blur="";Category="nature";;
    picsum) Provider="https://picsum.photos";Blur="";Category="nature";;
    *) craptastic=craptastic+1;;
  esac
  if [ $craptastic -gt 0 ]; then
    >&2 echo "Variables defined for imgholder but not parseable"
    show_help
    exit 1
  fi
}

################################################################################
# Bulding the curl string
################################################################################
curl_time() {
  declare urlstring
  echo "$Provider"
  if [ "$Provider" == "http://lorempixel.com" ]; then
    urlstring=$(echo "$Provider/$Xpx/$Ypx/$Category$Blur -O $Outfile")
    echo "$urlstring"
    wget $urlstring
    echo "Image written to $Outfile"
  elif [ "$Provider" == "http://source.unsplash.com" ];then
    urlstring=$(echo "$Provider/"$Xpx"x"$Ypx" -O $Outfile")
    echo "$urlstring"
    wget $urlstring
    echo "Image written to $Outfile"  
  elif [ "$Provider" == "https://picsum.photos" ];then
    urlstring=$(echo "$Provider/"$Xpx"/"$Ypx" -O $Outfile")
    echo "$urlstring"
    wget $urlstring
    echo "Image written to $Outfile"  
  else
    urlstring=$(echo "$Provider/$Xpx/$Ypx/$Category$Blur -o $Outfile --max-time 60 --create-dirs -s")
    echo "$urlstring"
    curl $urlstring
    echo "Image written to $Outfile"
  fi
}

################################################################################
# Wherein our hero tells the user what's what.
################################################################################
show_help() {
  echo "Usage is imgholder.sh with the following *optional* arguments"
  echo "-x [#]  X resolution of the resulting image (default 512)"
  echo "-y [#]  Y resolution of the resulting image (default 512)"
  echo "-p [placeimg|lorempixel|picsum|unsplash] Source of image (default unsplash)"
  echo "-o [path/filename] Complete path of output"
  echo "-c [category] Category of image (placeimg and lorempixel only)"
}

################################################################################
# Wherein things get told to happen
################################################################################
main() {
  check_variables
  curl_time
	exit 0
}

main
