#!/bin/sh
#
# Bootstrap script for setting up a new OSX machine
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
# - Else
xcode-select −install
#
# Reading:
#
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    composer
    git
    wget
    yarn
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew tap caskroom/cask

CASKS=(
    1password
    alfred
    authy
    #bartender
    dropbox
    firefox
    google-chrome
    iterm2
    rambox
    secure-pipes
    #slack
    spectacle
    #spotify
    sketch
    sublime-text
    toggl
    transmit
    tunnelblick
    vagrant
    virtualbox
    vlc
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-inconsolidata
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}

# echo "Installing Python packages..."
# PYTHON_PACKAGES=(
#     ipython
#     virtualenv
#     virtualenvwrapper
# )
# sudo pip install ${PYTHON_PACKAGES[@]}

# echo "Installing Ruby gems"
# RUBY_GEMS=(
#     bundler
#     filewatcher
#     cocoapods
# )
# sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

#Enable dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'

#Enable dark menubar and dock only
defaults write -g NSRequiresAquaSystemAppearance -bool Yes

#Store screenshots in ~/screenshots
defaults write com.apple.screencapture location ~/screenshots

defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Maybe displace notice about installing additional apps not found in brew?
# https://ashchan.com/projects/gmail-notifr


echo "Bootstrapping complete"

echo "Installing Oh-my-zsh"
#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
