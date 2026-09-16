# dotfiles

My yearly reminder for [GNU stow](https://www.gnu.org/software/stow/) as I don't change machines that often..

Mental model for me, stow <package> basically takes whatever is in the directory you call it from, in this case ~/dotfiles (but could be anywhere you clone this), then looks at whatever is in the <package> folder and symlinks from your actual $HOME to whatever is in the <package> folder.

> By default, Stow assumes the parent directory of the repository is the target.
> So ~/dotfiles → target is ~


Example:
```
~/dotfiles
  /mypackage
    /.config
      /mypackage.config.yamlson
```

Running `gnu stow mypackage` will create a symlink:

`~/.config/mypackage.config.yamlson -> ~/dotfiles/mypackage/.config/mypackage.config.yamlson`

If a file already exists it will complain. If you want to take whatever is there and move it from there to your dotfiles adn create the symlink in one action use `stow --adopt <package>` but this of course only works for stuff you have already defined in dotfiles.

If for some app no config file exists yet, simply `stow <app>` to implement your dotfiles config for that app. If the default install already places config files there, you need to delete/move them, I don't think there is a force overwrite.

## Bootstrap / the folding gotcha

Run `./bootstrap.sh` (optionally with package names) instead of bare `stow`.

Stow **folds** directories: if `~/.local` does not exist yet, `stow shell` creates
`~/.local -> dotfiles/shell/.local` as a single symlink. From then on *every* tool
that writes to `~/.local/bin`, `~/.local/share` or `~/.local/state` (Claude Code,
pipx, uv, ...) writes straight into this repo. `bootstrap.sh` pre-creates those
shared directories so stow only links the files this repo owns. If you see
hundreds of MB of untracked files under `shell/.local/share`, that is what happened:
move them to the real `~/.local/share`, remove the `~/.local` symlink, and restow.

`.stowrc` in the repo root sets `--target=$HOME` and ignores `.DS_Store`
(a `.stow-global-ignore` is only honoured at `~/.stow-global-ignore`, not here).

Machine-specific stuff that must not be committed goes in `~/.profile.local`,
`~/.bashrc.local`, `~/.zshrc.local`. Installers that append to `~/.zshrc` etc.
are appending to a symlink into this repo: move their line into
`shell/.local/profile.d/00-path.sh` (guarded by `path_prepend`/`path_append`) and
drop it from the rc file.

## Updating an existing machine

First time after these changes (no `dots` there yet):

```
cd ~/dotfiles && git pull && ./bootstrap.sh
```

`bootstrap.sh` unfolds a symlinked `~/.local` by itself (moving installer files
to the real `~/.local`), restows, and sets the git options. Open a new shell:
`dots` is on PATH from then on and the nudge is active. Afterwards it is only
ever `dots sync`. If `git pull` refuses because of local edits, `git stash`
first, or commit them with `git add -A && git commit -m wip` and let
`dots sync` sort out the rest.

## Keeping machines in sync: `dots`

`dots` (in `shell/.local/bin`) wraps the git dance so nothing has to be remembered:

```
dots            # status: uncommitted / unpushed / unpulled
dots sync       # commit everything, pull --rebase, push, restow if new commits came in
dots sync "msg" # same, with your own commit message
dots fetch      # fetch and show status
dots git <...>  # git inside the repo from anywhere
cd "$(dots dir)"
```

Every interactive login prints one line on stderr when the clone is out of sync
(`profile.d/60-dots-nudge.sh`). It fetches from origin in the background at most
once a day, using ssh BatchMode so it never prompts. Workflow: change something,
see the nudge next time a shell opens, type `dots sync`. On the other machine the
nudge says "unpulled", type `dots sync`. Done.

Shared shell functions (`ta`, `mkcd`) live in `shell/.local/profile.d/20-functions.sh`
and must stay POSIX; only completion goes in `.bashrc` / `.zshrc`.
