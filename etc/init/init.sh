#!/bin/bash

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

cd ~/.dotfiles/etc/init/"$PLATFORM"/

for script in *; do
	e_newline && e_header "Run File $script"
	cat $script | bash
done
