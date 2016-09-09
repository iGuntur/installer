#!/bin/bash

## get architecture machine
ARCH=$(uname -m)

## PATH to save files
NOW=$(date +"%m-%d-%Y")
TMP_DOWNLOAD="$HOME/.tmp/programming-app__$NOW"


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

# add PPA
print_message \
"Adding PPA" "\

    * ${green}ppa:nginx/stable     - [Web Server]${normal}
    * ${green}ppa:ondrej/php5      - [PHP5]${normal}
    * ${green}ppa:ondrej/php       - [PHP7]${normal}
    * ${green}ppa:webupd8team/java - [Java]${normal}
"
sudo apt-add-repository -y ppa:nginx/stable
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-add-repository -y ppa:ondrej/php5
sudo apt-add-repository -y ppa:webupd8team/java

# update repositoriy
print_message "Running update package lists"
sudo apt-get update

# install base package
print_message \
"Running install" "\
* ${green}python-software-properties${normal}
"
sudo apt-get install -y python-software-properties


# install git
print_message \
"Running install" "\

    * ${green}git${normal}
    * ${green}git-core${normal}
"
sudo apt-get install -y git git-core

# install java8
# http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
print_message \
"Running install" "\
* ${green}oracle-java8-installer${normal}
"
sudo apt-get install -y oracle-java8-installer

# install apache2 web server
# "Running install Apache2" "\
# print_message \
# * ${green}apache2${normal}
# "
# sudo apt-get install -y apache2

# install nginx web server
print_message \
"Running install Nginx" "\
* ${green}nginx${normal}
"
sudo apt-get install -y nginx

# install MySQL Server
print_message \
"Setup MySQL Server 5.6" "\

    * ${green}[default] root_password: root${normal}
    * ${green}mysql-server-5.6${normal}
"
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server-5.6

# install php5 with specifiec packages
print_message \
"Running install PHP5 with specifiec packages" "\

    * ${green}php5${normal}
    * ${green}libapache2-mod-php5${normal}
    * ${green}php5-curl${normal}
    * ${green}php5-gd${normal}
    * ${green}php5-mcrypt${normal}
    * ${green}php5-mysql${normal}
"
sudo apt-get install -y php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql

# install php7.0 php7.0-fpm
print_message \
"Running install" "\

    * ${green}php7.0${normal}
    * ${green}php7.0-fpm${normal}
"
sudo apt-get install -y php7.0 php7.0-fpm

# install node.js v6
print_message \
"Setup Node.js [v6]" "\
Install nodejs (as root)
  ${bold}${blue}https://nodejs.org/en/download/package-manager${normal}
"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

print_message \
"Installing Build Essential" "\
\`${blue}apt-get install build-essential${normal}\`
"
sudo apt-get install -y build-essential

# install composer
print_message \
"Setup composer" "\

    * ${green}Downloading composer.phar - https://getcomposer.org/composer.phar${normal}
    * ${green}Save to \`/usr/local/bin/composer\` (as root)${normal}
"
cd ~
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# npm install global package manager and stuff
print_message \
"Running install" "\

    * ${green}npm  - [global] (as root)${normal}
    * ${green}gulp - [global] (as root)${normal}
"
sudo npm install -g npm
sudo npm install -g gulp



# ----------------------------------------------------------------------------


##
## Install from *.deb
##


download_64bit () {
    print_message "Downloading GitKraken"
    wget https://release.gitkraken.com/linux/gitkraken-amd64.deb -P $TMP_DOWNLOAD

    print_message "Downloading Vagrant"
    wget https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.deb -P $TMP_DOWNLOAD
}


download_32bit () {
    print_message "Downloading Vagrant"
    wget https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_i686.deb -P $TMP_DOWNLOAD
}



install_dpkg () {
    local file=""
    for file in $TMP_DOWNLOAD/*.deb; do
        echo
        echo "## Running install \`dpkg -i $file\` (as root)"

        sudo dpkg -i $file
        sudo apt-get install -y -f
    done
}


## create a new folder
print_message "Create temporary directorie "$TMP_DOWNLOAD" for you"
mkdir -p $TMP_DOWNLOAD


## Download files
print_message "Starting download package"
if [ "$ARCH" == "64bit" ]; then download_64bit; else download_32bit; fi

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
        [Nn] ) print_message "Your files keep saved"; break;;
        * ) echo "Please enter y [for yes] or n [for no].";;
    esac
done

print_message "Done !!!"
