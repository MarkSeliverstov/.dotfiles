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
    if [ -d "$HOME/.oh-my-zsh" ]; then
        local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
        for plugin in "${ZSH_PLUGINS[@]}"; do
            info "installing $plugin"
            if [ -d "$custom_dir/plugins/$plugin" ]; then
                success "$plugin already installed"
                continue
            fi

            if git clone https://github.com/zsh-users/"$plugin" \
                "$custom_dir/plugins/$plugin"; then
                success "$plugin installed"
            else
                fail "error installing $plugin"
            fi
        done
        success "oh-my-zsh plugins installed"
    else
        fail "$HOME/.oh-my-zsh not found, install oh-my-zsh first"
    fi
}


install_oh_my_zsh_theme() {
    if ! ask_user "Do you want to install powerlevel10k theme? [y/n]"; then
        info "skipped installing powerlevel10k theme"
        return
    fi

    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    info "Installing powerlevel10k theme"
    if [ -d "$custom_dir/themes/powerlevel10k" ]; then
        success "powerlevel10k theme already installed"
    else
        if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "$custom_dir/themes/powerlevel10k"; then
            success "powerlevel10k theme installed"
        else
            fail "error installing powerlevel10k theme"
        fi
    fi
}

setup_zsh() {
    install_oh_my_zsh
    install_oh_my_zsh_plugins
    install_oh_my_zsh_theme
}

