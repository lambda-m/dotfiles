export PATH="$PATH:$HOME/.local/bin"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/maarten/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/maarten/.cache/lm-studio/bin"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# MPS fallback
export PYTORCH_ENABLE_MPS_FALLBACK=1

# because python sucks, or zsh...
export VIRTUAL_ENV_DISABLE_PROMPT=1

# This function is what actually sets and unsets the prompt
function _update_virtual_env_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    # Set the prompt to the venv name and the user's default prompt
    # `PROMPT` is the prompt for Zsh
    PROMPT="($(basename "$VIRTUAL_ENV")) %n@%m %1~ %# "
  else
    # If no venv is active, revert the prompt to the default
    PROMPT="%n@%m %1~ %# "
  fi
}

# This Zsh hook runs after every command
# It ensures the prompt is always correct
precmd_functions+=(_update_virtual_env_prompt)

# Tab completions for Make
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit

# Optionally import ~/.local/profile.d/*.sh (fail silently)
if [[ -d "$HOME/.local/profile.d" ]]; then
  for f in "$HOME/.local/profile.d"/*.sh; do
    [[ -e "$f" ]] || continue
    source "$f"
  done
fi
unset f
