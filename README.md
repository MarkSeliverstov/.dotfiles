# Ma:construction:k's Dotfiles

`macOS` | `homebrew` | `alacritty` | `zsh` | `tmux` | `nvim` | `git` | `fonts`

## Symlinks

Setting up your environment this way is really amazing. You simply tweak the
configurations here, and voila, they seamlessly apply to your entire system via
symlinks.

- `./.config`: -> `~/.config` - Contains **Alacrity**, **nvim** configs
- `./bin`: -> `~/.bin` - Anything in bin/ will get added to your $PATH and be made available everywhere.
- `.zshrc`: -> `~/.zshrc` - Zsh config
- `.tmux.conf`: -> `~/.tmux.conf` - Tmux config
- `.hushlogin`: -> `~/.hushlogin` - Hide login message in terminal
- `.gitconfig`: -> `~/.gitconfig` - Git config

## Install

```terminal
git clone git@github.com:MarkSeliverstov/.dotfiles.git
cd .dotfiles
chmod +x ./scripts/bootstrap.sh
./scripts/bootstrap.sh
```

### What it will do

- Set up macOS defaults
- Install **Homebrew** and **Homebrew Casks** (tmux, fzf, zsh, nvim, alacrity ...)
- Set up **zsh**, **oh-my-zsh** and **powerlevel10k**
- Set up **nvim**
- Set up **tmux**
- Set up **Alacritty**
- Downloand and setup **fonts** (JetBrainsMono, NerdFonts)
- Also in `./rectangle` you can find config for **Rectangle** app
