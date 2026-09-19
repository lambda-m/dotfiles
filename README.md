# dotfiles

**Lost? Open [MANUAL.html](MANUAL.html) in a browser** (`open ~/dotfiles/MANUAL.html`): one-page map of
the repo, the `dots` and `upd` commands, per-package quirks, and fixes for the usual mishaps.

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

## What needs updating: `upd`

`upd` (in `shell/.local/bin`) checks the package managers present on the machine:
brew, global npm packages (ccstatusline lives there), apt, dnf, pacman.

```
upd            # cached results per manager
upd check      # refresh now (brew update, npm outdated -g, ...)
upd upgrade    # per manager: show the list, ask y/N, upgrade
upd upgrade npm
```

Every interactive login prints one line on stderr when something is outdated
(`profile.d/70-upd-nudge.sh`), e.g. `updates: brew 2 (git, tmux), npm 1 (ccstatusline) -> upd`.
The expensive part (`brew update`, registry lookups) runs detached in the
background at most once a day, so login stays instant. Nothing is upgraded
unless you answer `y` in `upd upgrade`. Results live in `~/.local/state/upd`.

## What should be installed: `brew/`

`upd` answers "is anything outdated". `brew/` answers "what belongs on this
machine at all". Layered Brewfiles, one per Mac, applied by hand. Nothing here
runs automatically: no stow package, no login hook, `bootstrap.sh` ignores it.

```
brew/Brewfile.common       # all three Macs: every formula, the universal casks
brew/Brewfile.maxbookpro   # + everything else (this one is the superset)
brew/Brewfile.mini         # + office extras
brew/Brewfile.air          # + daily-driver extras
brew/MANUAL.md             # the handful Homebrew cannot install
```

The per-machine name is `uname -n`, lowercased — `MaxBookPro` gives
`Brewfile.maxbookpro`. `10-env.sh` uses that to set `HOMEBREW_BUNDLE_FILE`
automatically. On a machine whose hostname does not match a file, either rename
the file or set a short hostname once:

```sh
sudo scutil --set ComputerName mini
sudo scutil --set HostName mini
sudo scutil --set LocalHostName mini
```

The per-machine files `instance_eval` the common one (Brewfiles are Ruby), so
you always pass a machine file and never `Brewfile.common` — passing the common
file alone would make `cleanup` offer to uninstall every machine-specific
package.

```
brew bundle install --file=brew/Brewfile.air --no-upgrade # install what is missing
brew bundle check   --file=brew/Brewfile.air --no-upgrade # what is missing here
brew bundle cleanup --file=brew/Brewfile.air              # DRY RUN: what is unlisted
brew bundle cleanup --file=brew/Brewfile.air --force      # actually uninstall
```

**Always pass `--no-upgrade`.** Without it, `brew bundle` treats *outdated* as
unsatisfied: `check` reports installed-but-old packages as missing, and `install`
quietly turns into a mass `brew upgrade` of everything on the machine. Upgrading
is `upd`'s job; these files only answer "is it installed".

Both of these are set for you by `profile.d/10-env.sh` — `HOMEBREW_BUNDLE_NO_UPGRADE`
always, and `HOMEBREW_BUNDLE_FILE` when a file matching this hostname exists. In
a fresh shell, `brew bundle check` / `install` / `cleanup` need no flags at all:

```
brew bundle check      # this machine's manifest, presence only
brew bundle install    # install what is missing, upgrade nothing
brew bundle cleanup    # dry run: what is installed but unlisted
```

Day to day, install and record in one step, then sync:

```
brew bundle add --cask obsidian --install   # install AND write it down
brew bundle remove --cask obsidian          # drop the line
dots sync
```

**Never run `brew bundle dump` at any of these paths.** It rewrites the whole
file and would destroy the `instance_eval` lines. `brew bundle add` appends and
leaves them intact; dump only ever goes to a scratch path.

Setting up a machine, or checking an old one:

```
cd ~/dotfiles && dots sync
brew bundle cleanup --file=brew/Brewfile.mini              # 1. what is here, unlisted?
brew bundle check   --file=brew/Brewfile.mini --no-upgrade # 2. what is listed, missing?
#    promote keepers with `brew bundle add ... --file=brew/Brewfile.{mini,common}`
brew bundle install --file=brew/Brewfile.mini              # 3. fill the gaps
```

Survey before installing, or you install forty things before seeing what is
already there. Step 1 is always non-destructive, so it doubles as the drift
check months later.
