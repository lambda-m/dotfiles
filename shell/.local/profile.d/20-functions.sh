# Shared POSIX shell functions (sourced by sh, bash and zsh).
# Shell-specific completion for these lives in ~/.bashrc / ~/.zshrc.

mkcd() {
  if [ $# -eq 0 ]; then
    printf 'usage: mkcd <dir>\n' >&2
    return 2
  fi
  mkdir -p -- "$1" || return
  cd -- "$1" || return
}

# ta [name]: attach to the tmux session <name> (default: main), creating it if
# needed. Inside tmux it switches the client instead of nesting.
ta() {
  _ta_name="${1:-main}"
  if ! tmux has-session -t "=$_ta_name" 2>/dev/null; then
    tmux new-session -d -s "$_ta_name" || return
  fi
  if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "=$_ta_name"
  else
    tmux attach-session -t "=$_ta_name"
  fi
}
