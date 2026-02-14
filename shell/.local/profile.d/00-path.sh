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

# --- common paths ---
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/go/bin"

# --- macOS specific ---
if [ "$OS" = "Darwin" ]; then
  path_prepend "/opt/homebrew/bin"
  path_prepend "/opt/homebrew/opt/libpq/bin"
  path_prepend "$HOME/.rd/bin"
  path_prepend "$HOME/.cache/lm-studio/bin"
fi

# --- Linux specific ---
if [ "$OS" = "Linux" ]; then
  path_prepend "/usr/local/bin"
fi

export PATH
