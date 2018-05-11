#!/bin/bash
# A script to make switching PHP versions easier and more efficient.

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`
BGRED="$(tput setab 1)"
BGREEN="$(tput setab 2)"
FGWHITE="$(tput setaf 7)"
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

echo "Select Your PHP Version to ${BGRED}${FGWHITE}${BOLD} STOP ${NORM} [5.6,7.0,7.1]"
read PHPSTOPSELECTION

echo "Select Your PHP Version to ${BGREEN}${FGWHITE}${BOLD} START ${NORM} [5.6,7.0,7.1]"
read PHPSTARTSELECTION

brew services stop php@$PHPSTOPSELECTION    
brew services start php@$PHPSTARTSELECTION
brew link --overwrite php@$PHPSTARTSELECTION --force
sed -i '92s/.*/export PATH=\"\/usr\/local\/opt\/php@'$PHPSTARTSELECTION'\/bin:$PATH\" /' ~/.zshrc
sed -i '93s/.*/export PATH=\"\/usr\/local\/opt\/php@'$PHPSTARTSELECTION'\/sbin:$PATH\" /' ~/.zshrc

if [[ $PHPSTARTSELECTION = "7.0" ]];
then
  sed -i '93s/.*/        server unix:\/usr\/local\/var\/run\/php-fpm.sock;/' /usr/local/etc/nginx/nginx.conf
elif [[ $PHPSTARTSELECTION = "7.1" ]];
then
  sed -i '93s/.*/        server 127.0.0.1:9000;/' /usr/local/etc/nginx/nginx.conf
fi
