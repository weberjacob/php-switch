#!/bin/bash
# A script to make switching PHP versions easier and more efficient.

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`
#Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"
  echo -e \\n"Use to change ${BOLD}PHP-FPM variables${NORM} within your ${BOLD}nginx.conf${NORM} when switching Homebrew PHP Verions."\\n
  echo -e "${REV}Basic usage:${NORM} Declare PHP Version. Server Settings are as follows:"
  echo -e "${REV}7.0${NORM} - server unix:/usr/local/var/run/php-fpm.sock"
  echo -e "${REV}7.1${NORM} - server 127.0.0.1:9000"\\n
  exit 1
}

#Parse the params and flags.
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--help)
      HELP
      ;;
  esac
done

echo "Select Your PHP Version [5.6,7.0,7.1]"
read PHPSELECTION

if [[ $PHPSELECTION = "7.0" ]] 
then
  brew services stop php@7.1
  brew services start php@7.0
  brew link --overwrite php@7.0 --force
  sed -i '93s/.*/        server unix:\/usr\/local\/var\/run\/php-fpm.sock;/' /usr/local/etc/nginx/nginx.conf
  sed -i '92s/.*/export PATH=\"\/usr\/local\/opt\/php@7.0\/bin:$PATH\" /' ~/.zshrc
  sed -i '93s/.*/export PATH=\"\/usr\/local\/opt\/php@7.0\/sbin:$PATH\" /' ~/.zshrc
elif [[ $PHPSELECTION = "7.1" ]]
then
  brew services stop php@7.0
  brew services start php@7.1
  brew link --overwrite php@7.1 --force
  sed -i '93s/.*/        server 127.0.0.1:9000;/' /usr/local/etc/nginx/nginx.conf
  sed -i '92s/.*/export PATH=\"\/usr\/local\/opt\/php@7.1\/bin:$PATH\" /' ~/.zshrc
  sed -i '93s/.*/export PATH=\"\/usr\/local\/opt\/php@7.1\/sbin:$PATH\" /' ~/.zshrc
elif [[ $PHPSELECTION = "5.6" ]]
then
  echo "Why are you using 5.6? Silly!"
fi
