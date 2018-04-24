#!/bin/bash

#Install nodebrew
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install

e_newline && e_arrow "Install Nodebrew"
curl -L git.io/nodebrew | perl - setup

e_newline && e_header "Terminal Solarized & Azusa-Colors Download"

TarBalls=(
"https://github.com/sanographix/azusa-colors/archive/master.tar.gz"
"https://github.com/tomislav/osx-terminal.app-colors-solarized/archive/master.tar.gz"
)

cd ~/Downloads
for tarball in ${TarBalls[@]}; do
	tmpName=${tarball#*//*/*/}
	DirName=${tmpName%%/*}
	mkdir ${DirName}
	if is_exists "curl"; then
	  curl -L "$tarball"
	elif is_exists "wget"; then
	  wget -O - "$tarball"
	fi | tar xvz -C ${DirName} --strip-components 1
	open ${DirName}
done

e_newline && e_success "other applicaion is installed"
