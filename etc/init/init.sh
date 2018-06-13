#!/bin/bash

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_newline && e_header "Run Common Initialize"
cd ~/.dotfiles/etc/init/common/
for script in *; do
	e_newline && e_header "Run File $script"
	bash $script
done

cd ~/.dotfiles/etc/init/"$PLATFORM"/

for script in *; do
	e_newline && e_header "Run File $script"
	bash $script
done
