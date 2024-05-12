#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/scripts/utils.sh"
source "$DOTFILES_ROOT/scripts/homebrew-setup.sh"
source "$DOTFILES_ROOT/scripts/zsh-setup.sh"
source "$DOTFILES_ROOT/scripts/dotfiles-setup.sh"
source "$DOTFILES_ROOT/scripts/macos-setup.sh"

set -e

DOTFILES_TO_LINK=(
    bin
    .config
    .tmux
    .tmux.conf
    .zshrc
    .hushlogin
    .gitconfig
    .gitignore_global
)

ZSH_PLUGINS=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)

HELLO_MESSAGE="
  This script will setup and install if not already installed:
  
  * macOS defaults
  * Homebrew and some applications
  * Oh-my-zsh and some plugins
  * Dotfiles

  If you want to install everything, press 'y' when prompted
  Press any key to continue..."


display_start_message() {
    echo -e "$HELLO_MESSAGE"
    read -rsn 1
    echo ""
}

function main() {
    display_start_message
    setup_macos
    echo ""
    setup_homebrew
    echo ""
    setup_zsh
    echo ""
    install_dotfiles

    success "All done! ✨"
    echo ""
    echo "  For changes to take effect, run 'source ~/.zshrc', tmux source ~/.tmux.conf and 'prefix + I' in tmux to install plugins"
}

main
