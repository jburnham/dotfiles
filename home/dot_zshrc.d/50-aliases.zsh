alias vim='nvim'

alias cm='chezmoi'
alias cm-edit-packages='vim ~/.local/share/chezmoi/home/.chezmoidata/packages.yaml'
alias timeout='gtimeout'

alias ls='eza --icons=always --no-permissions --octal-permissions --group --git --group-directories-first --time-style "+%Y-%m-%d %H:%M"'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias l='ls -la'
alias tree='ls -T'

# Interactively checkout a recent branch via fuzzy finder (fzf).
# Lists 50 most recently committed branches with date and last commit msg.
alias gmru="git for-each-ref --sort=-committerdate --count=50 refs/heads/ --format='%(HEAD) %(refname:short) | %(committerdate:relative) | %(contents:subject)'| fzf | sed -e 's/^[^[:alnum:]]*//' | cut -d' ' -f1| xargs -I _ git checkout _"
