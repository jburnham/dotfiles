# Chezmoi dotfiles

In this repo, the user refers to `chezmoi` as `cm` (e.g. "run cm diff", "cm apply"). Treat `cm` as a synonym for `chezmoi` in conversation; the actual shell command is still `chezmoi` unless a `cm` alias/shim exists on PATH.

## Layout
- `.chezmoiroot` points source state at `home/`. All managed paths live under
  `home/` (e.g. `home/dot_claude/`, `home/dot_local/bin/`).
- `home/.chezmoi.toml.tmpl` renders once per machine on `chezmoi init` →
  `~/.config/chezmoi/chezmoi.toml`. Prompts for `work_computer`; don't hardcode
  per-machine logic elsewhere — branch on `.work_computer` in templates.
- `home/dot_claude/modify_settings.json` is a chezmoi `modify_` script (jq).
  It mutates the *existing* `~/.claude/settings.json` in place rather than
  overwriting, so app-managed fields like `model`, `effortLevel`, `$schema` are
  preserved. Keys the script *does* set are authoritative.

## Editing managed files
- Always edit source files under `home/` (e.g. `home/dot_config/`) rather than
  deployed files under `~/` — live files get overwritten on the next
  `chezmoi apply`.
- If it's unclear whether a file is managed, run `chezmoi source-path <path>`
  to confirm before editing.
- Before running `chezmoi apply`, always show `chezmoi diff` and get confirmation.

## Diff
- `chezmoi diff` uses `delta` as the pager (configured in `.chezmoi.toml.tmpl`).
- `textconv` rules pipe `.claude/settings.json` and `.claude/settings.local.json`
  through `jq --sort-keys` before diffing so Claude Code's key-order churn
  doesn't show up as noise.

## Lefthook / linting
- `lefthook.yml` runs shellcheck + shfmt on `*.sh`, `*.bash`, and
  chezmoi-prefixed files (`modify_*`, `executable_*`) at commit time.
- `.shellcheckrc` disables SC2250 globally. Prefer inline
  `# shellcheck disable=CODE` with a comment for other false positives.
- shfmt config is `-i 2 -ci -bn -s` (2-space indent, no space around redirect
  operators).
- Shebang policy: use `#!/usr/bin/env bash`, not `#!/bin/bash`.
