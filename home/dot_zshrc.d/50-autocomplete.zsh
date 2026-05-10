source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

# Wait with autocompletion until typing stops for a certain amount of seconds
zstyle ':autocomplete:*' delay 0.1  # seconds (float)

# Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
