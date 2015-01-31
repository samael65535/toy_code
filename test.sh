#!/bin/bash
TOGGLE=`defaults read com.apple.finder AppleShowAllFiles -bool`
if [ "$TOGGLE"==0 ]; then
	# defaults write com.apple.finder AppleShowAllFiles -bool true
    echo "hehe"
else
	# defaults write com.apple.finder AppleShowAllFiles -bool false
    echo "haha"
fi
killall Finder

