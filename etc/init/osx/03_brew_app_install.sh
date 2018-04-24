#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
e_arrow "brew application installing"

BrewApp=(
the_platinum_searcher
go
peco
ghq
tig
gibo
wget
nkf
ghostscript
hub
tree
graphviz
)

for app in ${BrewApp[@]}; do
  brew install $app
done

e_success "brew application is installed"
