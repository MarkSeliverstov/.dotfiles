#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

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
  echo ''
  exit
}

link_file () {
    local src=$1 dst=$2
    if [ -e $dst ]
    then
        read -p "Rewrite $dst? [y/n]" -n 1 action
        [ "$action" == "y" ] && rm -rf $dst || return
    fi
    ln -s $src $dst
}


setup_homebrew() {
    # If we're on a Mac, let's install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
      info "installing dependencies"
      if source $DOTFILES_ROOT/homebrew/install.sh | while read -r data; do info "$data"; done
      then
        success "dependencies installed"
      else
        fail "error installing dependencies"
      fi
    fi
}

setup_macos() {
    # If we're on a Mac, let's install and setup it
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
    info 'Linking dotiles'
    dotfiles=(
        .config bin 
        .tmux.conf 
        .zshrc 
        .hushlogin
    )
    for file in "${dotfiles[@]}"; do
        link_file "$DOTFILES_ROOT/$file" "$HOME/$file"
    done
    success 'dotfiles linked'
}


install_oh_my_zsh() {
    info 'installing oh-my-zsh'
    # check if oh-my-zsh is installed
    if [ -d "$HOME/.oh-my-zsh" ]
    then
      success 'oh-my-zsh already installed'
      install_oh_my_zsh_plugins
      return
    fi

    if git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    then
      success 'oh-my-zsh installed'
      install_oh_my_zsh_plugins
    else
      fail 'error installing oh-my-zsh'
    fi

}

install_oh_my_zsh_plugins() {
    info 'installing oh-my-zsh plugins'
    if [ -d "$HOME/.oh-my-zsh/plugins" ]; then
        plugins=(
            zsh-syntax-highlighting 
            zsh-autosuggestions 
            zsh-completions
        )
        for plugin in "${plugins[@]}"; do
            info "installing $plugin"
            git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin
        done
        info 'Installing powerlevel10k theme'
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        success 'oh-my-zsh plugins installed'
    else
        fail 'error installing oh-my-zsh plugins'
    fi
}

insatll_fonts() {
    info 'installing fonts'
    if [ -d "$HOME/Library/Fonts" ]
    then
      info 'installing MesloLGS NF font'
      if cp $DOTFILES_ROOT/fonts/MesloLGS\ NF/*.ttf $HOME/Library/Fonts
      then
        success 'MesloLGS NF font installed'
      else
        fail 'error installing MesloLGS NF font'
      fi
    else
      fail 'error installing fonts'
    fi
}

setup_macos
setup_homebrew
install_oh_my_zsh
install_dotfiles

success 'Finished! For changes to take effect, restart your terminal'

echo ''
echo '  All installed!'

