install_brew() {
  if test ! "$(which brew)"
  then
    info "Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"
  fi
}

install_brew_plugins() {
    info "Installing Homebrew plugins"
    if brew bundle install --file ./Brewfile | while read -r data; do info "$data"; done
    then
        info "applications installed"
    else
        exit 1
    fi
}

setup_homebrew() {
    # If we"re on a Mac, let's install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
        info "installing homebrew and dependencies"
        if test ! "$(which brew)"; then
            if install_brew; then
                success "Homebrew installed"
            else
                fail "error installing Homebrew"
            fi
        else
            success "Homebrew already installed"
        fi

        if ! ask_user "Do you want to install Homebrew applications? [y/n]"; then
            info "skipped installing Homebrew applications"
            return
        fi

        if install_brew_plugins; then
            success "Homebrew applications installed"
        else
            fail "error installing Homebrew applications"
        fi
    fi
}
