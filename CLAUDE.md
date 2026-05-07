# Chezmoi dotfiles

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

## Diff
- `home/dot_local/bin/executable_chezmoi-diff` is the configured
  `diff.command`. It sort-keys `.claude/settings.json` via jq before diffing so
  Claude Code's key-order churn doesn't show up. Labels use `~/...` for
  copy-pasteable paths.
- Bootstrap caveat: on a brand-new machine, `chezmoi diff` errors until the
  first `chezmoi apply` installs the wrapper. This is accepted — don't try to
  work around it.

## Lefthook / linting
- `lefthook.yml` runs shellcheck + shfmt on `*.sh`, `*.bash`, and
  chezmoi-prefixed files (`modify_*`, `executable_*`) at commit time.
- `.shellcheckrc` disables SC2250 globally. Prefer inline
  `# shellcheck disable=CODE` with a comment for other false positives.
- shfmt config is `-i 2 -ci -bn -s` (2-space indent, no space around redirect
  operators).
- Shebang policy: use `#!/usr/bin/env bash`, not `#!/bin/bash`.
