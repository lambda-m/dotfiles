OS="$(uname -s)"

# Emacs defaults to terminal
if [ "$OS" = "Darwin" ]; then
  alias emacs="/opt/homebrew/bin/emacs -nw"
  alias emacs-gui="/opt/homebrew/bin/emacs"
else
  alias emacs="emacs -nw"
fi

# your existing alias
alias ytgrab='noglob ytgrab'

# common ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
