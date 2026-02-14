# ~/.local/profile.d/20-mkcd.sh
mkcd() {
  if [ $# -eq 0 ]; then
    printf 'usage: mkcd <dir>\n' >&2
    return 2
  fi
  mkdir -p -- "$1" || return
  cd -- "$1" || return
}
