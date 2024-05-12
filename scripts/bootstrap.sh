#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ""

info () {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ""
    exit
}

link_file () {
    local src=$1 dst=$2
    local base_dst=$(basename $dst)
    if [ -e $dst ]
    then
        user "~/$base_dst already exists in your system. Do you want to overwrite it? [y/n]"
        read -s -n 1 answer
        if [[ $answer != [Yy] ]]; then
            return
        else
            rm -rf $dst
        fi
    fi
    ln -s $src $dst
    success "linked $base_dst"
}


setup_homebrew() {
    # If we"re on a Mac, let's install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
        info "installing homebrew and dependencies"
        if test ! $(which brew); then
            if source $DOTFILES_ROOT/homebrew/install.sh | while read -r data; do info "$data"; done
            then
                success "Homebrew installed"
            else
                fail "error installing Homebrew"
            fi
        else
            success "Homebrew already installed"
        fi

        user "Do you want to install Homebrew applications? [y/n]"
        read -s -n 1 answer
        if [[ $answer != [Yy] ]]; then
            return
        fi

        if source $DOTFILES_ROOT/homebrew/install-apps.sh | while read -r data; do info "$data"; done
        then
            success "Homebrew applications installed"
        else
            fail "error installing Homebrew applications"
        fi
    fi
}

setup_macos() {
    # If we"re on a Mac, let"s install and setup it
    if [ "$(uname -s)" == "Darwin" ]
    then
        user "Do you want to setup macOS defaults? [y/n]"
        read -s -n 1 answer
        if [[ $answer != [Yy] ]]; then
            return
        fi

        info "Setup macOS defaults"
        if source $DOTFILES_ROOT/macos/set-defaults.sh
        then
            success "macOS defaults installed"
        else
            fail "error installing macOS defaults"
        fi
    fi
}

install_dotfiles () {
    user "Do you want to link dotfiles? [y/n]"
    read -s -n 1 answer
    if [[ $answer != [Yy] ]]; then
        return
    fi
    info "Linking dotiles"
    dotfiles=(
        bin
        .config
        .tmux
        .tmux.conf
        .zshrc
        .hushlogin
        .gitconfig
        .gitignore_global
    )
    for file in "${dotfiles[@]}"; do
        link_file "$DOTFILES_ROOT/$file" "$HOME/$file"
    done
    success "dotfiles linked"
}


install_oh_my_zsh() {
    user "Do you want to install oh-my-zsh? [y/n]"
    read -s -n 1 answer
    if [[ $answer != [Yy] ]]; then
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
            return
        fi
    fi
}

install_oh_my_zsh_plugins() {
    user "Do you want to install oh-my-zsh plugins? [y/n]"
    read -s -n 1 answer
    if [[ $answer != [Yy] ]]; then
        return
    fi

    info "installing oh-my-zsh plugins"
    if [ -d "$HOME/.oh-my-zsh/plugins" ]; then
        plugins=(
            zsh-syntax-highlighting
            zsh-autosuggestions 
            zsh-completions
        )

        for plugin in "${plugins[@]}"; do
            user "Do you want to install $plugin? [y/n]"
            read -s -n 1 answer
            if [[ $answer != [Yy] ]]; then
                continue
            fi
            
            # check if plugin is already installed
            info "installing $plugin"
            if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
                success "$plugin already installed"
                continue
            fi

            git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin 2>&1 | while read -r data; do info "$data"; done
            success "$plugin installed"
        done
    else
        fail "$HOME/.oh-my-zsh/plugins not found, error installing plugins"
    fi
}

install_oh_my_zsh_theme() {
    user "Do you want to install powerlevel10k theme? [y/n]"
    read -s -n 1 answer
    if [[ $answer != [Yy] ]]; then
        return
    fi

    info "Installing powerlevel10k theme"
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes" ]; then
        success "powerlevel10k theme already installed"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2>&1 | while read -r data; do info "$data"; done
        success "oh-my-zsh plugins installed"
    fi
}


setup_macos
setup_homebrew
install_oh_my_zsh
install_oh_my_zsh_plugins
install_oh_my_zsh_theme
install_dotfiles

success "All done!"
echo ""
echo "  For changes to take effect, run 'source ~/.zshrc', tmux source ~/.tmux.conf and 'prefix + I' in tmux to install plugins"

