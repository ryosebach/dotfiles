#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
e_arrow "brew installing"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

e_success "brew is installed"
