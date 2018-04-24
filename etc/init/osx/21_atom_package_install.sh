#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_newline && e_arrow "atom package installing"
AtomPackage=(
language-plantuml
plantuml-viewer
linter
Sublime-Style-Column-Selection
)

for app in ${AtomPackage[@]}; do
  apm install $app
done
e_newline && e_success "atom package is installed"
