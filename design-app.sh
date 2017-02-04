#!/bin/bash

## get architecture machine
ARCH=$(uname -m)

## PATH to save files
NOW=$(date +"%m-%d-%Y")
TMP_DOWNLOAD="$HOME/.tmp/design-app__$NOW"


##
## Utils !!!
##


if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

print_message () {
    title="$1"; text="$2"

    echo
    echo "${magenta}--------------------------------------------------------------------------------${normal}"
    echo -e "  ${bold}${yellow}${title}${normal}"
    if [ -n "$text" ]; then
        echo
        echo -en "  ${text}"
        echo
    fi
    echo "${magenta}--------------------------------------------------------------------------------${normal}"
}


cd ~

# checking architecture machine
#    x86_64 => 64bit
#    i686 | i386 => 32bit
if [ "$ARCH" == "x86_64" ]; then
    ARCH="64bit"
else
    ARCH="32bit"
fi

# update reposository
print_message \
"Updating packages list" "\
\`${red}apt-get update${normal}\`
"
sudo apt-get update

# print_message \
# "Upgrading packages list" "\
# \`${red}apt-get upgrade${normal}\`
# "
# sudo apt-get upgrade -y

# print_message "Running \"apt-get install -f\""
# sudo apt-get install -y -f

print_message "Running \"apt install gimp\""
sudo apt install gimp -y

print_message \
"Running install gimp" "\

    * ${green}gimp${normal}
"


print_message "Running \"apt install Inkscape\""
sudo apt install inkscape -y

print_message \
"Running install Inkscape" "\

    * ${green}Inkscape${normal}
"
print_message "Done !!!"
