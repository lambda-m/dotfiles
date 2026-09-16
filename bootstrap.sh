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

# Repair a folded ~/.local from an earlier bare `stow shell`. Anything under
# shell/.local that git does not track was dropped there by installers
# (Claude Code, pipx, ...): move it to the real ~/.local before restowing.
if [ -L "$HOME/.local" ]; then
  echo "~/.local is a symlink into the repo; unfolding it" >&2
  rm "$HOME/.local"
  mkdir -p "$HOME/.local"
  git ls-files -o --directory shell/.local | while IFS= read -r p; do
    p=${p%/}
    dest="$HOME/${p#shell/}"
    echo "  moving $p -> $dest" >&2
    mkdir -p "$(dirname "$dest")"
    mv "$p" "$dest"
  done
fi

mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/state"

# Emacs only reads ~/.config/emacs when ~/.emacs.d and ~/.emacs do not exist.
# An emacs started without config creates an empty ~/.emacs.d, which then
# shadows the stowed config forever. Remove it if empty, warn otherwise.
rmdir "$HOME/.emacs.d" 2>/dev/null || true
for shadow in "$HOME/.emacs.d" "$HOME/.emacs" "$HOME/.emacs.el"; do
  [ -e "$shadow" ] && echo "warning: $shadow exists and will shadow ~/.config/emacs" >&2
done

# Git behaviour that keeps several clones in sync without thinking:
# pull rebases instead of merging, first push of a branch sets upstream.
git config pull.rebase true
git config push.autoSetupRemote true

if [ $# -gt 0 ]; then
  pkgs="$*"
else
  pkgs="core shell bash zsh tmux emacs"
  case "$(uname -s)" in
    Darwin) pkgs="$pkgs ghostty ccstatusline" ;;
  esac
fi

# -R restows: idempotent, and repairs links after files move within a package.
# shellcheck disable=SC2086
stow -R $pkgs
echo "stowed: $pkgs"
