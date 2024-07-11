install_oh_my_zsh() {
    if ! ask_user "Do you want to install oh-my-zsh? [y/n]"; then
        info "skipped installing oh-my-zsh"
        return
    fi

    # check if oh-my-zsh is installed
    if [ -d "$HOME/.oh-my-zsh" ]
    then
        success "oh-my-zsh already installed"
    else
        info "installing oh-my-zsh"
        if git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 2>&1 | while read -r data; do info "$data"; done
        then
            success "oh-my-zsh installed"
        else
            fail "error installing oh-my-zsh"
        fi
    fi
}

install_oh_my_zsh_plugins() {
    if ! ask_user "Do you want to install oh-my-zsh plugins? [y/n]"; then
        info "skipped installing oh-my-zsh plugins"
        return
    fi

    info "installing oh-my-zsh plugins"
    if [ -d "$HOME/.oh-my-zsh/plugins" ]; then
        for plugin in "${ZSH_PLUGINS[@]}"; do
            if ! ask_user "Do you want to install $plugin? [y/n]"; then
                info "skipped installing $plugin"
                continue
            fi
            
            # check if plugin is already installed
            info "installing $plugin"
            if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
                success "$plugin already installed"
                if ! grep -q "$plugin" "$HOME/.zshrc"; then
                    write_plugin_to_zshrc "$plugin"
                    info "$plugin not found in zshrc, I added it for you <3"
                fi
                continue
            fi

            git clone https://github.com/zsh-users/"$plugin" \
                "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin" \
                2>&1 | while read -r data; do info "$data"; done
            success "$plugin installed"
            write_plugin_to_zshrc "$plugin"
            success "$plugin added to zshrc"
        done
        success "oh-my-zsh plugins installed"
    else
        fail "$HOME/.oh-my-zsh/plugins not found, error installing plugins"
    fi
}

write_plugin_to_zshrc() {
  if ! grep -q "$1" "$HOME/.zshrc"; then
    echo "plugins+=($1)" >> "$HOME/.zshrc"
  fi
}

install_oh_my_zsh_theme() {
    if ! ask_user "Do you want to install powerlevel10k theme? [y/n]"; then
        info "skipped installing powerlevel10k theme"
        return
    fi

    info "Installing powerlevel10k theme"
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes" ]; then
        success "powerlevel10k theme already installed"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
            2>&1 | while read -r data; do info "$data"; done
        success "oh-my-zsh plugins installed"
    fi
}

setup_zsh() {
    install_oh_my_zsh
    install_oh_my_zsh_plugins
    install_oh_my_zsh_theme
}

