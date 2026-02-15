#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
e_arrow "brew application installing"

BrewApp=(
fzf
gh
ghq
d-kuro/tap/gwq
tig
nkf
tree
)

for app in ${BrewApp[@]}; do
  brew install $app
done

e_success "brew application is installed"
