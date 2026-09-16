# Once per login: one line on stderr if the dotfiles clone has uncommitted,
# unpushed or unpulled changes. `dots nudge` fetches in the background at most
# once a day, so this costs a few local git calls. Interactive shells only.
case $- in *i*) ;; *) return 0 ;; esac
if [ -z "${DOT_NUDGED:-}" ] && command -v dots >/dev/null 2>&1; then
  dots nudge
fi
export DOT_NUDGED=1
