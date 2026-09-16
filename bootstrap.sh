#!/bin/sh
# Stow dotfiles packages into $HOME. Usage:
#   ./bootstrap.sh              # stow the default set for this OS
#   ./bootstrap.sh zsh tmux     # stow only the named packages
#
# Why the mkdir step: stow "folds" a directory into a single symlink when it
# does not exist yet in $HOME. If ~/.local becomes a symlink into this repo,
# every installer that writes to ~/.local/{bin,share,state} (Claude Code,
# pipx, uv, ...) dumps its files into the repo. Pre-creating the shared
# directories makes stow link only the things this repo actually owns.
set -eu
cd "$(dirname "$0")"

mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/state"

if [ $# -gt 0 ]; then
  pkgs="$*"
else
  pkgs="core shell bash zsh tmux"
  case "$(uname -s)" in
    Darwin) pkgs="$pkgs ghostty ccstatusline" ;;
  esac
fi

# -R restows: idempotent, and repairs links after files move within a package.
# shellcheck disable=SC2086
stow -R -v $pkgs
