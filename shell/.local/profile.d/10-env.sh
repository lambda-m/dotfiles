# Cross-shell environment

# Editor: Emacs via the daemon when installed (emacs-cli comes from the emacs
# package), otherwise the best terminal editor present.
if command -v emacsclient >/dev/null 2>&1 && command -v emacs-cli >/dev/null 2>&1; then
  EDITOR="emacs-cli"
elif command -v vim >/dev/null 2>&1; then
  EDITOR="vim"
else
  EDITOR="vi"
fi
VISUAL="$EDITOR"
export EDITOR VISUAL
export PAGER="${PAGER:-less}"

# Python
export VIRTUAL_ENV_DISABLE_PROMPT=1

# macOS ML fallback
if [ "$(uname -s)" = "Darwin" ]; then
  export PYTORCH_ENABLE_MPS_FALLBACK=1
fi
