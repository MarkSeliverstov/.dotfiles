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


setup_git_identity() {
    if [ -f "$HOME/.gitconfig-local" ]; then
        info "git identity already configured"
        return
    fi

    info "Setting up git identity"
    printf "  Enter your personal git name: "
    read -r git_name
    printf "  Enter your personal git email: "
    read -r git_email
    printf '[user]\n\tname = %s\n\temail = %s\n' "$git_name" "$git_email" > "$HOME/.gitconfig-local"
    success "personal git identity configured"

    if ask_user "Do you want to set up a separate work git identity? [y/n]"; then
        printf "  Enter your work git name: "
        read -r work_name
        printf "  Enter your work git email: "
        read -r work_email
        printf '[user]\n\tname = %s\n\temail = %s\n' "$work_name" "$work_email" > "$HOME/.gitconfig-work-local"
        success "work git identity configured"
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

    setup_git_identity
}

