# Cross-shell environment

# Editor: Emacs via the daemon when installed (emacs-cli comes from the emacs
# package), otherwise the best terminal editor present.
if command -v emacsclient >/dev/null 2>&1 && command -v emacs-cli >/dev/null 2>&1; then
  EDITOR="emacs-cli"
elif command -v vim >/dev/null 2>&1; then
  EDITOR="vim"
else
  EDITOR="vi"
fi
VISUAL="$EDITOR"
export EDITOR VISUAL
export PAGER="${PAGER:-less}"

# Python
export VIRTUAL_ENV_DISABLE_PROMPT=1

# macOS ML fallback
if [ "$(uname -s)" = "Darwin" ]; then
  export PYTORCH_ENABLE_MPS_FALLBACK=1
fi

# Homebrew Bundle (brew/ in this repo).
#
# NO_UPGRADE is not optional: without it `brew bundle` counts *outdated* as
# unsatisfied, so `check` reports installed-but-old packages as missing and
# `install` turns into a mass `brew upgrade` of the whole machine. These files
# answer "is it installed"; upgrading is upd's job.
#
# BUNDLE_FILE picks this machine's manifest by hostname, the same way dots
# derives it (uname -n, lowercased): MaxBookPro -> brew/Brewfile.maxbookpro.
# No match (a new or renamed machine) leaves it unset, so brew falls back to
# ./Brewfile and nothing surprising happens.
if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_BUNDLE_NO_UPGRADE=1
  _bundle="${DOTFILES:-$HOME/dotfiles}/brew/Brewfile.$(uname -n | cut -d. -f1 | tr '[:upper:]' '[:lower:]')"
  [ -f "$_bundle" ] && export HOMEBREW_BUNDLE_FILE="$_bundle"
  unset _bundle
fi
