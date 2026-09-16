# --------------------------------------------------
# Load shared cross-shell environment
# --------------------------------------------------
[ -f "$HOME/.profile" ] && . "$HOME/.profile"


# --------------------------------------------------
# Prompt handling (Python virtualenv aware)
# --------------------------------------------------
function _update_virtual_env_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    PROMPT="($(basename "$VIRTUAL_ENV")) %n@%m %1~ %# "
  else
    PROMPT="%n@%m %1~ %# "
  fi
}

precmd_functions+=(_update_virtual_env_prompt)


# --------------------------------------------------
# Zsh completion
# --------------------------------------------------
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit

# Completion for ta (function lives in ~/.local/profile.d/20-functions.sh)
_ta() { compadd -- ${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"} }
compdef _ta ta


# --------------------------------------------------
# Optional local overrides (machine-specific)
# --------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

