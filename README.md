# Mark's Dotfiles

`macOS` | `alacritty` | `zsh` | `tmux` | `nvim` | `homebrew`

## Symlinks

By the way it is incredible way to setup enviroment. You can just edit configs
here and it will apply to your system (your symlinks).

- `./.config`: -> `~/.config` - Contains **Alacrity**, **nvim** configs
- `./bin`: -> `~/.bin` - Anything in bin/ will get added to your $PATH and be made available everywhere.
- `.zshrc`: -> `~/.zshrc`
- `.tmux.conf`: -> `~/.tmux.conf`
- `.hushlogin`: -> `~/.hushlogin` - Hide login message in terminal

## Install

```terminal
git clone
cd dotfiles
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
