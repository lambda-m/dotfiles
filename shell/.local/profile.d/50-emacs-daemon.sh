# Start Emacs daemon if not already running
if command -v emacs >/dev/null 2>&1; then
  if ! pgrep -u "$USER" emacs >/dev/null 2>&1; then
    command emacs --daemon >/dev/null 2>&1
  fi
fi
