nsafe() {
    local profile=$1
    shift
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

    nono run --profile "safe-$profile" --allow-cwd --allow "$project_dir" -- "$@"
}

nsafe-claude() { nsafe claude claude --dangerously-skip-permissions "$@" }
nsafe-codex()  { nsafe codex codex --dangerously-bypass-approvals-and-sandbox "$@" }
nsafe-opencode() { OPENCODE_DISABLE_FFF=1 nsafe opencode opencode "$@" }
nsafe-pi() { nsafe pi pi "$@" }
