# Start Emacs daemon if not already running
# Use \emacs to bypass aliases (works in both bash and zsh)
if \emacs --version >/dev/null 2>&1; then
  if ! pgrep -u "$USER" emacs >/dev/null 2>&1; then
    \emacs --daemon >/dev/null 2>&1
  fi
fi
