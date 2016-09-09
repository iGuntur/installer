#!/bin/bash

VIRTUALBOX_NAME="VirtualBox"
VIRTUALBOX_VERSION="5.1"
VIRTUALBOX_PKG="virtualbox-$VIRTUALBOX_VERSION"

INSTALL_VBOX_EXTPACK="yes"
INSTALL_VBOX_DKMS="yes"

DISTRO=$(lsb_release -c -s)

while true; do
    read -p "Do you want to include install VBox Extension Pack? [y|n|Y|N] " yn
    case $yn in
        [Yy]* ) INSTALL_VBOX_EXTPACK="yes"; break;;
        [Nn]* ) INSTALL_VBOX_EXTPACK="no"; break;;
        * ) echo "Please enter yes or no.";;
    esac
done

while true; do
    read -p "Do you want to include install dkms? [y|n|Y|N] " yn
    case $yn in
        [Yy]* ) INSTALL_VBOX_DKMS="yes"; break;;
        [Nn]* ) INSTALL_VBOX_DKMS="no"; break;;
        * ) echo "Please enter yes or no.";;
    esac
done

print_message () {
    echo
    echo "## $1"
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

check_dist () {
    if [ "${DISTRO}" == "${2}" ]; then
        DISTRO_CURRENT="${1} \"${2}\""
        DISTRO_MAPS="${3} \"${4}\""
        DISTRO="${4}"
    fi
}

get_dist () {
    # based debian or ubuntu distributions
    check_dist "Ubuntu"  "precise"  "Ubuntu"  "precise"
    check_dist "Ubuntu"  "quantal"  "Ubuntu"  "quantal"
    check_dist "Ubuntu"  "raring"   "Ubuntu"  "raring"
    check_dist "Ubuntu"  "trusty"   "Ubuntu"  "trusty"
    check_dist "Ubuntu"  "utopic"   "Ubuntu"  "utopic"
    check_dist "Ubuntu"  "vivid"    "Ubuntu"  "vivid"
    check_dist "Ubuntu"  "xenial"   "Ubuntu"  "xenial"
    check_dist "Ubuntu"  "lucid"    "Ubuntu"  "lucid"
    check_dist "Debian"  "wheezy"   "Debian"  "wheezy"
    check_dist "Debian"  "squeeze"  "Debian"  "squeeze"
    check_dist "Debian"  "jessie"   "Debian"  "jessie"

    # alternative distributions
    check_dist "Kali"          "sana"             "Debian"  "jessie"
    check_dist "Kali"          "kali-rolling"     "Debian"  "jessie"
    check_dist "Debian"        "stretch"          "Debian"  "jessie"
    check_dist "Linux Mint"    "maya"             "Ubuntu"  "precise"
    check_dist "Linux Mint"    "qiana"            "Ubuntu"  "trusty"
    check_dist "Linux Mint"    "rafaela"          "Ubuntu"  "trusty"
    check_dist "Linux Mint"    "rebecca"          "Ubuntu"  "trusty"
    check_dist "Linux Mint"    "rosa"             "Ubuntu"  "trusty"
    check_dist "Linux Mint"    "sarah"            "Ubuntu"  "xenial"
    check_dist "LMDE"          "betsy"            "Debian"  "jessie"
    check_dist "elementaryOS"  "luna"             "Ubuntu"  "precise"
    check_dist "elementaryOS"  "freya"            "Ubuntu"  "trusty"
    check_dist "elementaryOS"  "loki"             "Ubuntu"  "xenial"
    check_dist "Trisquel"      "toutatis"         "Ubuntu"  "precise"
    check_dist "Trisquel"      "belenos"          "Ubuntu"  "trusty"
    check_dist "BOSS"          "anokha"           "Debian"  "wheezy"
    check_dist "bunsenlabs"    "bunsen-hydrogen"  "Debian"  "jessie"
    check_dist "Tanglu"        "chromodoris"      "Debian"  "jessie"
}

setup_vbox_master () {
    print_message "Installing the $VIRTUALBOX_NAME version $VIRTUALBOX_VERSION"
    print_message "Checking Based Linux distributions..."
    get_dist

    echo
    echo "## You seem to be using ${DISTRO_CURRENT}."
    echo "## This maps to ${DISTRO_MAPS} ..."

    print_message "Confirming your Linux distributions ${DISTRO_MAPS} is supported..."

    print_message "Adding the VirtualBox signing key to your keyring..."
    if [ "${DISTRO}" == "xenial" ] || [ "${DISTRO}" == "jessie" ]; then
        echo
        wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    else
        echo
        wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    fi

    print_message "Creating apt sources list file for the according your distribution \"${DISTRO}\" repo..."
    exec_cmd "echo 'deb http://download.virtualbox.org/virtualbox/debian ${DISTRO} contrib' > /etc/apt/sources.list.d/virtualbox.list"

    print_message 'Running `apt-get update` for you...'
    sudo apt-get update

    print_message "Running \`apt-get install ${VIRTUALBOX_PKG}\` (as root) to install ${VIRTUALBOX_NAME} version ${VIRTUALBOX_VERSION} ..."

    echo
    sudo apt-get install -y $VIRTUALBOX_PKG
}

setup_vbox_dkms () {
    print_message "Running \`apt-get install dkms\` (as root) ..."
    echo
    sudo apt-get install -y dkms
}

setup_vbox_extpack () {
    print_message "Preparing VirtualBox Extension Pack..."

    VBOXMANAGE=$(vboxmanage -v)
    VBOXMANAGE_VERSION=$(echo $VBOXMANAGE | cut -d 'r' -f 1)
    VBOXMANAGE_RELEASED=$(echo $VBOXMANAGE | cut -d 'r' -f 2)
    VBOX_EXTPACK="Oracle_VM_VirtualBox_Extension_Pack-$VBOXMANAGE_VERSION-$VBOXMANAGE_RELEASED.vbox-extpack"

    print_message "Downloading VirtualBox Extension Pack \"$VBOX_EXTPACK\""

    mkdir -p ~/.tmp
    wget http://download.virtualbox.org/virtualbox/$VBOXMANAGE_VERSION/$VBOX_EXTPACK -O ~/.tmp/$VBOX_EXTPACK

    print_message "Saving VirtualBox Extension Pack to \"~/.tmp/$VBOX_EXTPACK\""

    print_message "Installing \`$VBOX_EXTPACK\` (as root) ..."
    sudo VBoxManage extpack install ~/.tmp/$VBOX_EXTPACK --replace
    rm ~/.tmp/$VBOX_EXTPACK
}

# Trigger to run setup installations
setup_vbox_master
print_message "$VIRTUALBOX_NAME version $VIRTUALBOX_VERSION successfully installed..."

if [ "$INSTALL_VBOX_DKMS" == "yes" ]; then
    setup_vbox_dkms
    print_message "dkms successfully installed..."
fi

if [ "$INSTALL_VBOX_EXTPACK" == "yes" ]; then
    setup_vbox_extpack
    print_message "VirtualBox Extension Pack successfully installed..."
fi

print_message "Done..."
