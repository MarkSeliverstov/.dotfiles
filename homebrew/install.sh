#!/bin/bash
#
# Homebrew install script

# Check for Homebrew
if test ! $(which brew)
then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"

    echo "  Do you want to install Homebrew plugins? (y/n)"
    read -p "y/n: " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      if source brew bundle install --file ./Brewfile | while read -r data; do echo "$data"; done
      then
        echo "applications installed"
      else
        echo "error installing applications"
      fi
    fi
fi

exit 0
