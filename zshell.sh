#!/bin/bash

# Install ZShell and .oh-my-zsh
#   https://github.com/robbyrussell/oh-my-zsh


##
## Utils !!!
##

print_message () {
    echo
    echo "| $1 ..."
}

echo "|===================================================="
echo "| Manually change your default shell to zsh [ZShell]"
echo "| run this from your CLI -> chsh -s \$(which zsh)"
echo "| after installation is done"
echo "|"
echo "| Read More"
echo "|    https://github.com/robbyrussell/oh-my-zsh"
echo "|===================================================="

## Script
main () {
    # update reposository
    print_message "Running update reposository"
    sudo apt-get update

    # install zsh
    print_message "Preparing for install (zsh) ZShell"

    print_message "Running install \"apt-get install zsh\" (as root)"
    sudo apt-get install -y zsh

    print_message "Download and setting up .oh-my-zsh"

    cd ~
    print_message "Installing .oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

while true; do
    echo "|"
    read -p "| Continue to install? [y|n|Y|N] " yn
    echo "|"
    case $yn in
        [Yy] ) main; break;;
        [Nn] ) echo "| Cancelled"; exit 1;;
        * ) echo "| Please enter y [for yes] or n [for no].";;
    esac
done
