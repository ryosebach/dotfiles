#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_arrow "brew cask application installing"

ConfirmApp=(
"mp3tag"
"kap"
"marp"
"insomnia"
"hyperswitch"
"spectacle"
"visual-studio"
)
brew tap caskroom/versions
brew cask install alfred
brew cask install clipy
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install google-chrome-canary
brew cask install franz
brew cask install the-unarchiver
brew cask install vlc
brew cask install adobe-creative-cloud
brew cask install atom

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
