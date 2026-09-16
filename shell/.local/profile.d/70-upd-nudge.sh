# Once per login: one line on stderr if brew / npm -g / apt / dnf / pacman have
# outdated packages, from a cache that `upd` refreshes in the background at most
# once a day. Never upgrades anything by itself. Interactive shells only.
case $- in *i*) ;; *) return 0 ;; esac
if [ -z "${UPD_NUDGED:-}" ] && command -v upd >/dev/null 2>&1; then
  upd nudge
fi
export UPD_NUDGED=1
