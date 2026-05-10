## History command configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=999999999       # the number of items for the internal history list
export SAVEHIST=999999999       # maximum number of items for the history file
setopt extended_history         # record timestamp of command in HISTFILE
setopt hist_expire_dups_first   # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups         # ignore duplicated commands history list
setopt hist_ignore_space        # ignore commands that start with space
setopt hist_verify              # show command with history expansion to user before running it
setopt inc_append_history_time  # append command to history file immediately after execution
unsetopt share_history          # do not share history between multiple zsh sessions

export DO_NOT_TRACK=true
export EDITOR=nvim
export GH_TELEMETRY=false
export HOMEBREW_NO_ANALYTICS=1
export NIX_PATH="$HOME/.nix-defexpr"
export SSH_AUTH_SOCK="~/.ssh/agent"

# zsh-autosuggestions plugin
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# END zsh-autosuggestions plugin

eval "$(brew shellenv)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/main.toml)"
eval "$(zoxide init --cmd cd zsh)"
