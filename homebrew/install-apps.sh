
#!/bin/bash
#
# Homebrew plugins installer

function install_brew_plugins() {
    echo "  Installing Homebrew plugins"
    if brew bundle install --file ./Brewfile | while read -r data; do echo "$data"; done
    then
        echo "applications installed"
    else
        exit 1
    fi
}

if [ "$(uname)" == "Darwin" ]; then
  if [ "$(which brew)" ]; then
    install_brew_plugins
  else
    echo "  Homebrew not installed. Skipping."
    exit 1
  fi
fi

exit 0
