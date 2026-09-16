# Idempotent PATH helpers
path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="$1${PATH:+:$PATH}";; esac
}

path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="${PATH:+$PATH:}$1";; esac
}

OS="$(uname -s)"

# --- macOS specific ---
if [ "$OS" = "Darwin" ]; then
  path_prepend "/opt/homebrew/bin"
  path_prepend "/opt/homebrew/opt/libpq/bin"
  path_prepend "$HOME/.rd/bin"
  # LM Studio CLI (lms): older installs used ~/.cache/lm-studio/bin, newer ~/.lmstudio/bin
  path_prepend "$HOME/.cache/lm-studio/bin"
  path_append "$HOME/.lmstudio/bin"
fi

# --- Linux specific ---
if [ "$OS" = "Linux" ]; then
  path_prepend "/usr/local/bin"
fi

# --- user paths last, so they end up FIRST and shadow Homebrew/system tools ---
# (a user-level script must beat e.g. Graphviz's /opt/homebrew/bin/dot)
path_prepend "$HOME/go/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

export PATH
