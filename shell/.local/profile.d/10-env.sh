# Cross-shell environment

export EDITOR="emacs -nw"
export VISUAL="emacs"
export PAGER="${PAGER:-less}"

# Python
export VIRTUAL_ENV_DISABLE_PROMPT=1

# macOS ML fallback
if [ "$(uname -s)" = "Darwin" ]; then
  export PYTORCH_ENABLE_MPS_FALLBACK=1
fi
