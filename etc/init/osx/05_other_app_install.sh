#!/bin/bash

#Install nodebrew
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install

e_newline && e_header "Install Nodebrew"
curl -L git.io/nodebrew | perl - setup

e_newline && e_header "Terminal Solarized Download"

TarBalls=(
"https://github.com/sanographix/azusa-colors/archive/master.tar.gz"
"https://github.com/tomislav/osx-terminal.app-colors-solarized/archive/master.tar.gz"
)

count=0
cd ~/Downloads
for tarball in ${TarBalls[@]}; do
	mkdir "tarball${count}"
	if is_exists "curl"; then
	  curl -L "$tarball"
	elif is_exists "wget"; then
	  wget -O - "$tarball"
	fi | tar xvz -C "tarball${count}" --strip-components 1
	open "tarball${count}"
	count=`echo "$count+1" | bc`
done
