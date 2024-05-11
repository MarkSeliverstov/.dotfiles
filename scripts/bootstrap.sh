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
    if [ -e $dst ]
    then
        local message="File $dst already exists. Do you want to overwrite it? [y/n] "
        info "$message"
        read -n 1 action
        [ "$action" == "y" ] && rm -rf $dst || echo "" && continue
        echo ""
    fi
    ln -s $src $dst
}


setup_homebrew() {
    # If we"re on a Mac, let"s install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
      info "installing homebrew and dependencies"
      if source $DOTFILES_ROOT/homebrew/install.sh | while read -r data; do info "$data"; done
      then
        success "dependencies installed"
      else
        fail "error installing dependencies"
      fi
    fi
}

setup_macos() {
    # If we"re on a Mac, let"s install and setup it
    if [ "$(uname -s)" == "Darwin" ]
    then
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
    info "Linking dotiles"
    dotfiles=(
        bin
        .config
        .tmux
        .tmux.conf
        .zshrc
        .hushlogin
        .gitconfig
    )
    for file in "${dotfiles[@]}"; do
        link_file "$DOTFILES_ROOT/$file" "$HOME/$file"
    done
    success "dotfiles linked"
}


install_oh_my_zsh() {
    info "installing oh-my-zsh"
    # check if oh-my-zsh is installed
    if [ -d "$HOME/.oh-my-zsh" ]
    then
      success "oh-my-zsh already installed"
      install_oh_my_zsh_plugins
      return
    fi

    if git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 2>&1 | while read -r data; do info "$data"; done
    then
      success "oh-my-zsh installed"
      install_oh_my_zsh_plugins
    else
      fail "error installing oh-my-zsh"
    fi

}

install_oh_my_zsh_plugins() {
    info "installing oh-my-zsh plugins"
    if [ -d "$HOME/.oh-my-zsh/plugins" ]; then
        plugins=(
            zsh-syntax-highlighting
            zsh-autosuggestions 
            zsh-completions
        )

        for plugin in "${plugins[@]}"; do
            info "installing $plugin"
            if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
                success "$plugin already installed"
                continue
            fi
            git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin 2>&1 | while read -r data; do info "$data"; done
            success "$plugin installed"
        done

        info "Installing powerlevel10k theme"
        if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes" ]; then
            success "powerlevel10k theme already installed"
        else
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2>&1 | while read -r data; do info "$data"; done
            success "oh-my-zsh plugins installed"
        fi
    else
        fail "$HOME/.oh-my-zsh/plugins not found, error installing plugins"
    fi
}

setup_macos
setup_homebrew
install_oh_my_zsh
install_dotfiles

success "Finished! For changes to take effect, run 'source ~/.zshrc'"
info "Also you need to run 'tmux source-file ~/.tmux.conf' and 'prefix + I' to install tmux plugins"

echo ""
echo "  All installed!"

