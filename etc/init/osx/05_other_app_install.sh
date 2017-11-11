#Install nodebrew
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install

e_newline && e_header "Install Nodebrew"
curl -L git.io/nodebrew | perl - setup


