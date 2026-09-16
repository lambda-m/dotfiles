# Emacs: connect to daemon, terminal mode, auto-start daemon if needed.
# Only when Emacs is actually installed, so `emacs` stays a clean "not found" otherwise.
if command -v emacsclient >/dev/null 2>&1; then
  alias emacs='emacsclient -nw -a ""'
  alias emacs-gui='emacsclient -c -a ""'
fi

# ytgrab takes URLs with ?&=; noglob is zsh-only (bash does not glob ?& in URLs anyway)
if [ -n "${ZSH_VERSION:-}" ]; then
  alias ytgrab='noglob ytgrab'
fi

# common ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
