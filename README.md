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

## Resources

- [chezmoi documentation](https://www.chezmoi.io/)
