# ~/.bashrc (bash-specific interactive config)

# TMUX
ta() {
    if tmux has-session -t "$1" 2>/dev/null; then
        tmux attach -t "$1"
    else
        tmux new-session -s "$1"
    fi
}

# (same completion function as above)
_ta() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(tmux list-sessions -F '#{session_name}' 2>/dev/null)" -- "$cur") )
}
complete -F _ta ta


# Machine-specific overrides
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
