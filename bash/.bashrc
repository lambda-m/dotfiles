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

# ---- optional modular profile.d includes ----
if [ -d "$HOME/.local/profile.d" ]; then
  for f in "$HOME/.local/profile.d"/*.sh; do
    [ -e "$f" ] || continue
    . "$f"
  done
fi
unset f

# ---- user overrides ----
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

export PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/maarten/.cache/lm-studio/bin"
# End of LM Studio CLI section

