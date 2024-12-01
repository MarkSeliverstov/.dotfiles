set_defaults() {
    # Sets reasonable macOS defaults.
    #
    # Or, in other words, set shit how I like in macOS.
    #
    # The original idea (and a couple settings) were grabbed from:
    #   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
    #
    # Run ./set-defaults.sh and you'll be good to go.

    # Disable press-and-hold for keys in favor of key repeat.
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Always open everything in Finder's list view. This is important.
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv

    # Show the ~/Library folder.
    chflags nohidden ~/Library

    # Set a really fast key repeat.
    defaults write NSGlobalDomain KeyRepeat -int 1

    # Change the Caps Lock key to act as the Control key
    # hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006e},{"HIDKeyboardModifierMappingSrc":0x7000000e0,"HIDKeyboardModifierMappingDst":0x7000000e4}]}'

    # Normal font in Alacrity terminal
    defaults write -g AppleFontSmoothing -int 0

    # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
    defaults write com.apple.dock expose-group-apps -bool true && killall Dock

    # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
    defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

    # Moving a macOS window by clicking anywhere on it (like on Linux)
    defaults write -g NSWindowShouldDragOnGesture -bool true
}

setup_macos() {
    # If we"re on a Mac, let"s install and setup it
    if [ "$(uname -s)" == "Darwin" ] && ask_user "Do you want to setup macOS defaults? [y/n]"; then
        info "Setup macOS defaults"
        if set_defaults; then
            success "macOS defaults installed"
        else
            fail "error installing macOS defaults"
        fi
    else
        info "skipped setting up macOS defaults"
    fi
}
