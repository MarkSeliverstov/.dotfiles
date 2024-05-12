link_file () {
    local src=$1 dst=$2
    base_dst=$(basename "$dst")

    if [ -e "$dst" ]; then
        if ask_user "$HOME/$base_dst already exists in your system. Overwrite it? [y/n]"; then
            rm -rf "$dst"
        else
            info "skipped $base_dst"
            return
        fi
    fi

    ln -sf "$src" "$dst"
    success "linked $base_dst"
}

setup_macos() {
    # If we"re on a Mac, let"s install and setup it
    if [ "$(uname -s)" == "Darwin" ] && ask_user "Do you want to setup macOS defaults? [y/n]"; then
        info "Setup macOS defaults"
        if source "$DOTFILES_ROOT/macos/set-defaults.sh"; then
            success "macOS defaults installed"
        else
            fail "error installing macOS defaults"
        fi
    else
        info "skipped setting up macOS defaults"
    fi
}


install_dotfiles () {
    if ! ask_user "Do you want to link dotfiles? [y/n]"; then
        info "skipped linking dotfiles"
        return
    fi
    info "Linking dotiles"
    for file in "${DOTFILES_TO_LINK[@]}"; do
        link_file "$DOTFILES_ROOT/$file" "$HOME/$file"
    done
    success "dotfiles linked"
}

