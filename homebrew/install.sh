#!/bin/bash
#
# Homebrew install script

function install_brew() {
  if test ! $(which brew)
  then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"
  fi
}

if [ "$(uname)" == "Darwin" ]; then
  install_brew
fi

exit 0
