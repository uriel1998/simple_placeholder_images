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
declare Blur
declare Provider
declare Outfile
declare Category
declare Scratch

Scratch="$@"
########################################################################
# options
# -x [#]
# -y [#]
# -p [placeimg|lorempixel]
# -o [path]
# -b (for blur)
# -c [category name]
# I should probably use getopt for this
########################################################################
parse_variables() {
  echo "$Scratch"
	if [[ "$Scratch" == *"-b"* ]]; then
    Blur="/?blur"
  fi
  if [[ "$Scratch" == *"-c "* ]]; then
		Category=$(echo "$Scratch" | awk -F "-c " '{print $2}')
  fi
  if [[ "$Scratch" == *"-x "* ]]; then
		Xpx=$(echo "$Scratch" | awk -F "-x " '{print $2}')
  fi
  if [[ "$Scratch" == *"-y "* ]]; then
    Ypx=$(echo "$Scratch" | awk -F "-y " '{print $2}')
  fi
  if [[ "$Scratch" == *"-p "* ]]; then
    Provider=$(echo "$Scratch" | awk -F "-p " '{print $2}')
  else
    Provider="placeimg"
  fi
  if [[ "$Scratch" == *"-o "* ]]; then
    Outfile=$(echo "$Scratch" | awk -F "-o " '{print $2}')
  else
    Outfile="$PWD/outfile.jpg"
  fi
  if [[ "$Scratch" == *"-h="* ]]; then
		show_help
    exit 0
  fi
}

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
  # Nobody but unsplash provides blur
  # Unsplash only has random for category
  # I'm temporarily hardcoding the category strings in.
  case $Provider in
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
  echo "-p [placeimg|lorempixel|photosum] Source of image (default unsplash)"
  echo "-o [path/filename] Complete path of output"
  echo "-b Engage blur on image (unsplash only)"
  echo "-c [category] Category of image (placeimg and lorempixel only)"
}

################################################################################
# Wherein things get told to happen
################################################################################
main() {
  parse_variables
  check_variables
  curl_time
	exit 0
}

main
