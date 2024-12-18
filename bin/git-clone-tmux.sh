#!/usr/bin/env bash

repo=""
directory=""
clone_path=""

repo="${1}"
directory="${2}"

[ -z "${repo}" ] && read -er -p "Repo: " repo
# [ -z "${directory}" ] && read -er -p "Directory: " directory
# Choose dir with fzf
[ -z "${directory}" ] && directory=$(find ~/git -maxdepth 1 -type d | fzf)

# Remove trailing .git
repo="${repo%.git}"
clone_path="${directory}/$(basename "${repo}")"

if [ -z "${repo}" ] || [ -z "${directory}" ]; then
    echo "Usage: git-clone-tmux.sh <repo> <directory>"
    exit 1
fi

# Ensure directory exists
if [ ! -d "${directory}" ]; then
    mkdir -p "${directory}"
fi

git clone "${repo}" "${clone_path}"
tmux new-session -d -s "$(basename "${repo}")" -c "${clone_path}"

# change session
tmux switch-client -t "$(basename "${repo}")"
