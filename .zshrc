# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Unaliasing all aliases
unalias -a

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:plugins:nvm' lazy yes # for lazy loading so terrible nvm...

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    git 
    nvm 
    zsh-syntax-highlighting
    zsh-autosuggestions
    poetry
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias make="/opt/homebrew/opt/make/libexec/gnubin/make"
alias ts="~/bin/tmux-sessionizer.sh"
alias tsg="~/bin/git-clone-tmux.sh"

alias dotfiles="cd ~/dotfiles"
alias venv="source .venv/bin/activate"
alias v="nvim"
alias pip="pip3.10"
# alias python="python3.10"
alias zshc="nvim ~/.zshrc"
alias nvimc="nvim ~/.config/nvim"
alias src="source ~/.zshrc"

# Functions

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Git checkout with fzf (all branches, sorting)
gch() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Exports
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:/Users/mark.seliverstov/.dotnet/tools:/Library/Apple/usr/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/mark.seliverstov/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:/Users/mark.seliverstov/.dotnet/tools:/Library/Apple/usr/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"
export EDITOR="nvim"

export CTO_LOGGING_LOG_FORMAT=PLAIN

# Poetry variables
export POETRY_VIRTUALENVS_IN_PROJECT=true
export POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY=false
export POETRY_REQUESTS_TIMEOUT=10000
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

eval "$(pyenv init --path)"
