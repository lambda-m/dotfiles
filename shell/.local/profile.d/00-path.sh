# Idempotent PATH helpers
path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="$1${PATH:+:$PATH}";; esac
}
path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="${PATH:+$PATH:}$1";; esac
}

# Common user bins
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

export PATH
