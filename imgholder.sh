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

########################################################################
# options
# -x [#]
# -y [#]
# -p [placeimg|lorempixel|unsplash]
# -o [path]
# -b (for blur)
# -c [category name]
# I should probably use getopt for this
########################################################################
parse_variables() {
  if [[ "$@" == *"-h "* ]]; then
		show_help
    exit 0
  fi
	if [[ "$@" == *"-b "* ]]; then
    echo "SHIT"
    Blur="/?blur"
  fi
  if [[ "$@" == *"-c "* ]]; then
		Category=$(echo "$@" | awk -F "-c " '{print $2}')
  fi
  if [[ "$@" == *"-x "* ]]; then
		Xpx=$(echo "$@" | awk -F "-x " '{print $2}')
  fi
  if [[ "$@" == *"-y "* ]]; then
    Ypx=$(echo "$@" | awk -F "-y " '{print $2}')
  fi
  if [[ "$@" == *"-p "* ]]; then
    Provider=$(echo "$@" | awk -F "-p " '{print $2}')
  else
    Provider="unsplash"
  fi
  if [[ "$@" == *"-o "* ]]; then
    Outfile=$(echo "$@" | awk -F "-o " '{print $2}')
  else
    Outfile="$PWD/outfile.jpg"
  fi
}

################################################################################
# Ensuring that either sane defaults are used, or user input is not insane.
################################################################################
check_variables(){
  declare -i craptastic=0
  case $Xpx in
      ''|*[!0-9]*) craptastic=craptastic+1 ;;
      *) echo good ;;
  esac
  case $Ypx in
      ''|*[!0-9]*) craptastic=craptastic+1 ;;
      *) echo good ;;
  esac
  # Nobody but unsplash provides blur
  # Unsplash only has random for category
  # I'm temporarily hardcoding the category strings in.
  case $Provider in
    placeimg) Provider="http://placeimg.com";Blur="";Category="nature";;
    lorempixel) Provider="http://lorempixel.com";Blur="";Category="nature";;
    unsplash) Provider="http://unsplash.it";Category="?random";;
    *) craptastic=craptastic+1;;
  esac
  if [ $craptastic -gt 0 ]; then
    >&2 echo "Variables defined and not parseable"
    show_help
    exit 1
  fi
}

################################################################################
# Bulding the curl string
################################################################################
curl_time() {
  declare urlstring

  urlstring=$(echo "$Provider/$Xpx/$Ypx/$Category$Blur -o $Outfile --max-time 60 --create-dirs")
  echo "$urlstring"
  curl $urlstring


}

################################################################################
# Wherein our hero tells the user what's what.
################################################################################
show_help() {
  echo "help"
  # -x [#]
  # -y [#]
  # -p [placeimg|lorempixel|unsplash]
  # -o [path]
  # -b (for blur)
  # -c [category name]
}

################################################################################
# Wherein things get told to happen
################################################################################

  parse_variables
  echo "variables parsed"
  check_variables
  echo "variables checked"
  echo "running curl"
  curl_time
  echo "curl ran"
	exit 0
