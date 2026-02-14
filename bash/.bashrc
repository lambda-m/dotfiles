# ---- PATH management helper ----
path_add() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

# ---- OS detection ----
OS="$(uname -s)"

# ---- common paths ----
path_add "$HOME/.local/bin"
path_add "$HOME/go/bin"
path_add "$HOME/.cache/lm-studio/bin"

# ---- OS-specific ----
if [ "$OS" = "Darwin" ]; then
  path_add "$HOME/.rd/bin"
fi

# ---- user overrides ----
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

export PATH
