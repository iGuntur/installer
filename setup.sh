#!/bin/bash


VERSION="0.0.1"
AUHTOR_NAME="Guntur Poetra"
AUHTOR_EMAIL="poetra.guntur@gmail.com"
HOMEPAGE="http://guntur.starmediateknik.com"


# setup all app...
#    - base app
#    - programming app
#    - virtualbox
#    - zshell


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

print_info () {
    TITLE="$1"; BODY="$2"

    echo
    echo "${bold}${red}================================================================================${normal}"
    echo -e "${bold}${blue}${TITLE}${normal}"
    echo "${bold}${red}================================================================================${normal}"
    echo
    echo -en "${BODY}"
    echo
    echo "${bold}${red}================================================================================${normal}"
}

print_info \
"                             Installer Application                             " "\
  This script is ${bold}my personal installer${normal} application on my ${bold}${green}Linux Machine.${normal}

  I'm beginner with [Shell Script]. Hoppefully your contributions
  to fix any issues and correct me if I'm wrong...

  For more ${bold}documentations${normal} and source code
    ${bold}${white}Github${normal} - ${magenta}https://github.com/iGuntur/installer${normal}


  ${yellow}@version:  ${VERSION}${normal}
  ${yellow}@author:   ${AUHTOR_NAME} <${AUHTOR_EMAIL}>${normal}
  ${yellow}@homepage: ${HOMEPAGE}${normal}
"



##
## start here...
##



# handling setup with curl
exec_cmd_curl () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/iGuntur/installer/master/base-app.sh)"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/iGuntur/installer/master/programming-app.sh)"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/iGuntur/installer/master/virtualbox.sh)"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/iGuntur/installer/master/zshell.sh)"
}


# handling setup with wget
exec_cmd_wget () {
    sh -c "$(wget https://raw.githubusercontent.com/iGuntur/installer/master/base-app.sh -O -)"
    sh -c "$(wget https://raw.githubusercontent.com/iGuntur/installer/master/programming-app.sh -O -)"
    sh -c "$(wget https://raw.githubusercontent.com/iGuntur/installer/master/virtualbox.sh -O -)"
    sh -c "$(wget https://raw.githubusercontent.com/iGuntur/installer/master/zshell.sh -O -)"
}


##
## execute setup after define script
##

waiting () {
    for (( i = $1; i > 0; i-- )); do
        sleep 1; echo "  $i..."
    done
}

setup () {
    echo
    echo "  Please wait..."
    echo "  Execute in 5 seconds..."
    echo "  If you want to cancel, Hit ${bold}${yellow}[ctrl+c]${normal} now !!!"
    echo
    waiting 5
    sleep 1
    echo
    echo "  ${bold}Installing...${normal}"
    echo

    if [ -x /usr/bin/curl ]; then
        exec_cmd_curl
    else
        exec_cmd_wget
    fi
}


##
## Asking to you
##

while true; do
    echo
    echo \
"  ${bold}Continue to install?${normal}
  ${green}[y|Y] => (yes) execute this program
  ${yellow}[n|N] => (no) to cancel${normal}
"
    read -p "  ${bold}Your Answer:${normal} " yn
    echo
    case $yn in
        [Yy] ) setup; break;;
        [Nn] ) echo "  ${bold}${red}Aborted${normal}"; break;;
        * ) echo "  ${bold}${red}Please answer ${green}y [yes]${white} or ${red}n [no]${normal}.";;
    esac
done

echo
echo "${bold}${blue}================================================================================${normal}"
echo "${bold}${green}  Thank You !!!${normal}";
echo "${bold}${blue}================================================================================${normal}"
echo
exit 1
