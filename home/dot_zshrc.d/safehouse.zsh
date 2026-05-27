export SAFEHOUSE_ADD_DIRS_RO=~/.config/oh-my-posh:~/.cloudflared
export SAFEHOUSE_ADD_DIRS=~/.memsearch
safe() {
    local resolved_home project_dir git_root
    resolved_home="$(cd "$HOME" && pwd -P)"
    project_dir="$(pwd -P)"
    git_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
    [[ -n $git_root ]] && project_dir="$(cd "$git_root" && pwd -P)"

    if [[ $project_dir == "$resolved_home" ]]; then
        echo "error: refusing to run from \$HOME ($resolved_home)" >&2
        echo "cd into a project directory first." >&2
        return 1
    fi

    local -a append_profile_args
    local profile
    for profile in ${HOME}/.config/safehouse/profiles/*.sb(N); do
        append_profile_args+=(--append-profile="$profile")
    done

    safehouse \
        --workdir="$project_dir" \
        "${append_profile_args[@]}" \
        "$@"
}

safe-claude() { safe claude --dangerously-skip-permissions "$@" }
safe-codex()  { safe codex "$@" }
