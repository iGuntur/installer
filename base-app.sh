#!/bin/bash

## get architecture machine
ARCH=$(uname -m)

## PATH to save files
NOW=$(date +"%m-%d-%Y")
TMP_DOWNLOAD="$HOME/.tmp/base-app__$NOW"


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



##
## Start here
##

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
\`${blue}apt-get update${normal}\`
"
sudo apt-get update

print_message \
"Upgrading packages list" "\
\`${blue}apt-get upgrade${normal}\`
"
sudo apt-get upgrade -y

print_message "Running \"apt-get install -f\""
sudo apt-get install -y -f

print_message "Running \"apt-get install build-essential\""
sudo apt-get install -y build-essential

# add PPA
print_message \
"Adding PPA" "\

    * ${green}ppa:synapse-core/ppa                 -  [Alt: Spotlight]${normal}
    * ${green}ppa:transmissionbt/ppa               -  [Torrent Transmission]${normal}
    * ${green}ppa:mpstark/elementary-tweaks-daily  -  [Elementary Tweaks]${normal}
"
sudo apt-add-repository -y ppa:mpstark/elementary-tweaks-daily
sudo apt-add-repository -y ppa:transmissionbt/ppa
sudo apt-add-repository -y ppa:synapse-core/ppa


# update reposository
print_message \
"Updating packages list" "\
\`${blue}apt-get update${normal}\`
"
sudo apt-get update

# Install Base Packages
print_message \
"Running install Base Packages" "\

    * ${green}vim${normal}
    * ${green}curl${normal}
"
sudo apt-get install -y vim curl

# install elementary tweaks
print_message \
"Running install Base Packages" "\
* ${green}elementary-tweaks${normal}
"
sudo apt-get install -y elementary-tweaks

# install transmission
print_message \
"Running install Torrent Transmission" "\

    * ${green}transmission-cli${normal}
    * ${green}transmission-common${normal}
    * ${green}transmission-daemon${normal}

    ${bold}${blue}https://help.ubuntu.com/community/TransmissionHowTo${normal}
"
sudo apt-get install -y transmission-cli transmission-common transmission-daemon

# install disk management
print_message \
"Running install Disk Management" "\

    * ${green}gnome-disk-utility${normal}
    * ${green}gparted${normal}
"
sudo apt-get install -y gnome-disk-utility
sudo apt-get install -y gparted


# install utilities
print_message \
"Running install utilities" "\

    * ${green}tree${normal}
    * ${green}synapse${normal}
    * ${green}dconf-editor${normal}
"
sudo apt-get install -y tree
sudo apt-get install -y synapse
sudo apt-get install -y dconf-editor


# Media player
print_message \
"Running install media player" "\

    * ${green}vlc${normal}
"
sudo apt-get install -y vlc

# Web Browser 32bit
if [ "$ARCH" == "32bit" ]; then
    print_message \
    "Running install web browser" "\

        * ${bold}${red}[for 64bit]${normal} - ${green}Google Chrome no longer supports 32-bit.${normal}
        * ${bold}${red}[for 32bit]${normal} - ${green}Chromium Browser is supported.${normal}

        Read More: http://askubuntu.com/questions/250773/how-do-i-install-chromium-from-the-command-line
    "
    sudo apt-get install -y chromium-browser
fi


# ----------------------------------------------------------------------------

##
## Install from *.deb
##


# handling download file
exec_cmd_download () {
    local DOWNLOAD_FILE="$1"

    if [ -x /usr/bin/curl ]; then
        curl -C - -O "$DOWNLOAD_FILE"
    else
        wget "$DOWNLOAD_FILE"
    fi
}


download_64bit () {
    # Web Browser
    #   http://askubuntu.com/questions/250773/how-do-i-install-chromium-from-the-command-line
    print_message \
    "Downloading Google Chrome web browser" "\

        * ${bold}${red}[for 64bit]${normal} - ${green}Google Chrome no longer supports 32-bit.${normal}
        * ${bold}${red}[for 32bit]${normal} - ${green}Chromium Browser is supported.${normal}

        Read More: http://askubuntu.com/questions/250773/how-do-i-install-chromium-from-the-command-line
    "
    exec_cmd_download "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

    print_message "Downloading SublimeText3"
    exec_cmd_download "https://download.sublimetext.com/sublime-text_build-3114_amd64.deb"
}

download_32bit () {
    print_message "Downloading SublimeText3"
    exec_cmd_download "https://download.sublimetext.com/sublime-text_build-3114_i386.deb"
}

remove_downloaded () {
    rm -rf "$TMP_DOWNLOAD"
    print_message "$TMP_DOWNLOAD directorie has been removed !!!"
}

install_dpkg () {
    for file in $TMP_DOWNLOAD/*.deb; do
        echo
        echo "## Running install \`dpkg -i $file\` (as root)"

        sudo dpkg -i $file
        sudo apt-get install -y -f
    done
    unset file
}

## create a new folder
print_message "Create temporary directorie "$TMP_DOWNLOAD" for you"
mkdir -p $TMP_DOWNLOAD


## Download files
print_message "Starting download package"
cd "$TMP_DOWNLOAD"
if [ "$ARCH" == "64bit" ]; then download_64bit; else download_32bit; fi
cd ~

print_message "Download succesfully"

# install each *.deb package
print_message "Starting to install each \"*.deb\" packages"
install_dpkg
print_message "Installing succesfully..."


# would you like to remove downloaded file or keep save it?
while true; do
    read -p "Do you want to remove temporary files in $TMP_DOWNLOAD directorie? [y|n|Y|N] " yn
    case $yn in
        [Yy] ) remove_downloaded; break;;
        [Nn] ) print_message "Your downloaded files keep save in $TMP_DOWNLOAD directorie"; break;;
        * ) echo "Please enter y [for yes] or n [for no].";;
    esac
done

print_message "Done !!!"
