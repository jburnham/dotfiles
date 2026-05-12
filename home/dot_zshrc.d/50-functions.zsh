zreload() {
  command rm -f $_comp_dumpfile
  local zsh="${ZSH_ARGZERO:-$0}"
  [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}
