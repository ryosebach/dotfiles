#!/bin/bash

#Install nodebrew
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install

e_newline && e_header "Install Nodebrew"
curl -L git.io/nodebrew | perl - setup

e_newline && e_header "Terminal Solarized Download"

tarball="https://github.com/tomislav/osx-terminal.app-colors-solarized/archive/master.tar.gz"

cd ~/Downloads
mkdir solarized
if is_exists "curl"; then
  curl -L "$tarball"
elif is_exists "wget"; then
  wget -O - "$tarball"
fi | tar xvz -C solarized --strip-components 1

open solarized/

#Install atom package
apm install plantuml-viewer
apm install language-plantuml
apm install Sublime-Style-Column-Selection
apm install linter
