# ~/.profile (shared)

# Load profile.d scripts
if [ -d "$HOME/.local/profile.d" ]; then
  for f in "$HOME/.local/profile.d"/*.sh; do
    [ -e "$f" ] || continue
    . "$f"
  done
fi
unset f

# If bash, load .bashrc
if [ -n "$BASH_VERSION" ]; then
  [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
