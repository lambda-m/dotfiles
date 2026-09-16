# ~/.bashrc (bash-specific interactive config)

# Completion for ta (function lives in ~/.local/profile.d/20-functions.sh)
_ta() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(tmux list-sessions -F '#{session_name}' 2>/dev/null)" -- "$cur") )
}
complete -F _ta ta

# Machine-specific overrides
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
