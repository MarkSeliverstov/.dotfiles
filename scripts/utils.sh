info () {
    printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] %s" "$1"
}

clear_line () {
    COLUMNS=$(tput cols)
    printf "\r%${COLUMNS}s\r"
}

ask_user () {
    user "$1"
    read -rsn 1 answer
    clear_line
    if [[ $answer != [Yy] ]]; then
        return 1
    fi
    return 0
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
    echo ""
    exit
}
