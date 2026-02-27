# Start Emacs daemon if not already running
# Use emacsclient -e to check if a server is responding (works regardless
# of process name across macOS/Linux/OpenBSD)
if \emacs --version >/dev/null 2>&1; then
  if ! emacsclient -e '(progn)' >/dev/null 2>&1; then
    \emacs --daemon >/dev/null 2>&1
  fi
fi
