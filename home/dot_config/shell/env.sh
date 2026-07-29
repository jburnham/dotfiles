# Portable environment shared by interactive zsh and the bash that AI agents run.
#
# Sourced by:
#   - ~/.zshrc.d/00-setup.zsh          (interactive shells)
#   - safehouse --env=<this file>       (sandboxed agents; safehouse runs
#                                        `env -i`, so without this they inherit
#                                        nothing and telemetry defaults to on)
#
# Keep it POSIX sh: no zsh arrays, no bashisms. safehouse sources it with
# `set -a` under /bin/bash, so plain assignments are exported too.
#
# Only non-secret, machine-independent values belong here — this file lands in
# every sandboxed agent's environment. Route credentials through
# `safehouse --env-pass=NAME` instead.

# shellcheck shell=sh

# Telemetry opt-outs. DO_NOT_TRACK must be exactly 1: gh accepts 1 or true, but
# stricter consumers test `=== '1'` and silently ignore "true".
# https://donottrack.sh/
export DO_NOT_TRACK=1
export GH_TELEMETRY=false
export HOMEBREW_NO_ANALYTICS=1

export EDITOR=nvim

# Prepend only if absent, so repeated sourcing can't duplicate entries.
# GOPATH is normally unset; ${GOPATH:-$HOME/go} matches `go env GOPATH` without
# shelling out to go, which may not be installed.
for _dir in "$HOME/.local/bin" "${GOPATH:-$HOME/go}/bin"; do
  case ":$PATH:" in
    *":$_dir:"*) ;;
    *) PATH="$_dir:$PATH" ;;
  esac
done
unset _dir
export PATH
