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
# Emacs-style line editing, even when $EDITOR contains "vi" (zsh would pick vi mode)
# --------------------------------------------------
bindkey -e


# --------------------------------------------------
# History (macOS /etc/zshrc keeps only 1000 lines; most Linux distros save none)
# --------------------------------------------------
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS


# --------------------------------------------------
# fzf: Ctrl-R fuzzy history, Ctrl-T files, Alt-C cd (only when fzf is installed)
# --------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  export FZF_CTRL_R_OPTS="--header 'type to filter · ↑↓ move · enter: paste · esc: cancel · ctrl-r: sort by time/relevance'"
  # fzf >= 0.48 prints its own integration; older distro packages ship files instead
  _fzf_init="$(fzf --zsh 2>/dev/null)"
  if [ -n "$_fzf_init" ]; then
    eval "$_fzf_init"
  else
    for f in /usr/share/doc/fzf/examples/key-bindings.zsh /usr/share/fzf/key-bindings.zsh /usr/share/fzf/shell/key-bindings.zsh; do
      [ -f "$f" ] && . "$f" && break
    done
  fi
  unset _fzf_init f
fi


# --------------------------------------------------
# Optional local overrides (machine-specific)
# --------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

