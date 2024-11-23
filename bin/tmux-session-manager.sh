#!/usr/bin/env bash
# amazing tmux sessions fuzy finder with ability 
# to kill sessions on the fly (by pressing `alt-d` on macOS)

# Session list excluding the current session command
CURRENT_SESSION=$(tmux display-message -p '#S')
SESSION_LIST_CMD="tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$CURRENT_SESSION$\""

# Fuzzy find session and switch to it (or kill it and reload the list)
eval "$SESSION_LIST_CMD" \
  | fzf --bind "∂:execute-silent(tmux kill-session -t {})+reload($SESSION_LIST_CMD)" \
  | xargs -r tmux switch-client -t
