# Start the Emacs daemon in the background for interactive shells, if Emacs is
# installed and no server answers yet. emacs-cli (-a "") would start one on
# demand anyway; pre-starting just makes the first editor call instant.
# emacsclient -e is used as the probe because process names differ across
# macOS/Linux/OpenBSD.
case $- in *i*) ;; *) return 0 ;; esac
if command -v emacs >/dev/null 2>&1 && command -v emacsclient >/dev/null 2>&1; then
  if ! emacsclient -e '(progn)' >/dev/null 2>&1; then
    (command emacs --daemon >/dev/null 2>&1 &)
  fi
fi
