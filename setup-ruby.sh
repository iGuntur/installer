#!/bin/bash

##
## Install ruby latest version on ubuntu 14.04
##     https://gorails.com/setup/ubuntu/14.04
##


print_info () {
	echo
	echo -e "## $1"
}

##
## Cleanup ~/.rbenv directory if it exists
##
if [ -d "$HOME/.rbenv" ] ; then
	print "rm -r $HOME/.rbenv"
	rm -r $HOME/.rbenv
fi


print_info "git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv"
git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
# exit 1

print_info "export PATH='$HOME/.rbenv/bin:$PATH' >> ~/.bashrc"
echo "export PATH=\"$HOME/.rbenv/bin:$PATH\"" >> ~/.bashrc

print_info "eval '$(rbenv init -)' >> ~/.bashrc"
echo "eval \"$(rbenv init -)\"" >> ~/.bashrc

print_info "exec $SHELL"
exec $SHELL


print_info "git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build"
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

print_info "export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH" >> ~/.bashrc"
echo "export PATH=\"$HOME/.rbenv/plugins/ruby-build/bin:$PATH\"" >> ~/.bashrc

print_info "exec $SHELL"
exec $SHELL

print_info "rbenv install 2.3.1"
rbenv install 2.3.1

print_info "rbenv global 2.3.1"
rbenv global 2.3.1

print_info "ruby -v"
ruby -v
