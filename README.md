# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)

## Usage

### Install

```sh
chezmoi init https://github.com/<username>/dotfiles.git
chezmoi diff
chezmoi apply
```

### Update

```sh
chezmoi update --apply=false
chezmoi diff
chezmoi apply
```

### Edit a managed file

```sh
chezmoi edit <file>
chezmoi diff
chezmoi apply
```

### Optional: internal-name scanning

This repo is public, so internal/work names must never be committed as
literals. To enable a pre-commit guard that scans staged files for them, copy
the example local lefthook config and fill in the real terms:

```sh
cp lefthook-local.yml.example lefthook-local.yml
# edit lefthook-local.yml: replace the placeholder terms with your real ones
```

`lefthook-local.yml` is gitignored, so the real terms stay off the public repo.
The hook fails the commit if any term appears in staged files; use a chezmoi
data variable instead (see `CLAUDE.md`).

## Resources

- [chezmoi documentation](https://www.chezmoi.io/)
