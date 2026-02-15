#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

if has brew; then
	e_success "brew is already installed"
else
	e_arrow "brew installing"

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	e_success "brew is installed"
fi
