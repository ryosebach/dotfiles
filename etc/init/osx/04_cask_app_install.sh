#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_arrow "brew cask application installing"

ConfirmApp=(
vlc
spectacle
intellij-idea
)

InstallApp=(
hyperswitch
docker
alfred
authy
notion
karabiner-elements
kap
bartender
clipy
java
trailer
visual-studio-code
docker
google-chrome
google-japanese-ime
the-unarchiver
)
brew tap caskroom/versions

for app in ${InstallApp[@]}; do
  brew install --cask $app
done

for app in ${ConfirmApp[@]}; do
	echo "Installing $app... OK? (y, N)"
	if yes_or_no; then
		echo "Install $app"
		brew cask install $app
	else
		echo "Skip installing $app"
	fi
done

e_success "brew cask application is installed"
