#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

pip install neovim
pip3 install neovim

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

