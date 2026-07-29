bindkey -e  # emacs line editing: ^A/^E, ^R, ^W, etc.

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

# Env vars and PATH shared with the bash that AI agents run. Also passed to
# sandboxed agents via `safehouse --env=` (see safehouse.zsh.tmpl) — edit that
# file to add a var everywhere at once.
source ~/.config/shell/env.sh

# zsh-only below: NIX_PATH and SSH_AUTH_SOCK stay here because they are
# machine-specific, and SSH_AUTH_SOCK's literal ~ relies on zsh expanding it.
export NIX_PATH="$HOME/.nix-defexpr"
export SSH_AUTH_SOCK="~/.ssh/agent"

# Names of host env vars to forward into safehouse sandboxes (see
# safehouse.zsh). Declared here, first in load order, so any later zshrc.d file
# can append without worrying about who runs first:
#
#     safehouse_env_pass+=(SOME_VAR)
#
# Append (+=), never assign (=), or you'll drop entries added before you.
# Only the name travels, never the value. Unset names are skipped silently,
# so listing one that only exists on some machines is fine.
typeset -ga safehouse_env_pass=()

# zsh-autosuggestions plugin
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# END zsh-autosuggestions plugin

eval "$(brew shellenv)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/main.toml)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(mise activate zsh)"
# Only run mise's env-refresh hook on directory change, not on every prompt.
# _mise_hook_chpwd (cd) still does the real work; precmd was redundantly
# re-running it on every command. Trade-off: config changes made without
# cd'ing away and back won't be picked up until the next cd.
# https://github.com/jdx/mise/discussions/2164
precmd_functions=(${precmd_functions:#_mise_hook_precmd})
