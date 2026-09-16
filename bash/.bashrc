# ~/.bashrc (bash-specific interactive config)

# Completion for ta (function lives in ~/.local/profile.d/20-functions.sh)
_ta() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(tmux list-sessions -F '#{session_name}' 2>/dev/null)" -- "$cur") )
}
complete -F _ta ta

case $- in
  *i*)
    # History: bigger, appended instead of overwritten, no duplicates
    HISTSIZE=50000
    HISTFILESIZE=50000
    HISTCONTROL=ignoreboth:erasedups
    shopt -s histappend

    # fzf: Ctrl-R fuzzy history, Ctrl-T files, Alt-C cd (only when fzf is installed)
    if command -v fzf >/dev/null 2>&1; then
      export FZF_CTRL_R_OPTS="--header 'type to filter · ↑↓ move · enter: paste · esc: cancel · ctrl-r: sort by time/relevance'"
      # fzf >= 0.48 prints its own integration; older distro packages ship files instead
      _fzf_init="$(fzf --bash 2>/dev/null)"
      if [ -n "$_fzf_init" ]; then
        eval "$_fzf_init"
      else
        for f in /usr/share/doc/fzf/examples/key-bindings.bash /usr/share/fzf/key-bindings.bash /usr/share/fzf/shell/key-bindings.bash; do
          [ -f "$f" ] && . "$f" && break
        done
      fi
      unset _fzf_init f
    fi
    ;;
esac

# Machine-specific overrides
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
