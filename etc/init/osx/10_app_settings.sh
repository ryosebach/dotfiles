#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_newline && e_arrow "some settings installing"

e_newline && e_header "mp3tag setting installing"
mp3tagDir=`\ls -1 ~/Library/Application\ Support/ | grep mp3tag`
if [ ! -z "$mp3tagDir" ] ; then
	echo "mp3tag setting"
	echo "[Software\\\\Wine\\\\Fonts\\\\Replacements]" >> ~/Library/Application\ Support/$mp3tagDir/user.reg
	echo "\"MS UI Gothic\"=\"Hiragino Maru Gothic ProN W4\"" >> ~/Library/Application\ Support/$mp3tagDir/user.reg
fi

e_newline && e_header "neovim settings linking"

test ! -r ~/.vim && mkdir ~/.vim
test ! -r ~/.config && mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
