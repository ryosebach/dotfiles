#!/bin/sh

test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect

e_newline && e_arrow "dock & trackpad plist installing"
echo "cp ~/.dotfiles/etc/lib/osx/plist/com.apple.dock.plist ~/Library/Preferences/"
cp ~/.dotfiles/etc/lib/osx/plist/com.apple.dock.plist ~/Library/Preferences/
echo "cp ~/.dotfiles/etc/lib/osx/plist/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist ~/Library/Preferences/"
cp ~/.dotfiles/etc/lib/osx/plist/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist ~/Library/Preferences/
