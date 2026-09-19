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

**`~/.bash_profile` must not exist.** A bash login shell reads the *first* of
`~/.bash_profile`, `~/.bash_login`, `~/.profile` and stops. Installers
(Rancher Desktop, LM Studio, rustup) like to create `~/.bash_profile`, which
silently shadows `~/.profile` and disables this entire repo under bash — no
`profile.d`, no `ta`, no PATH entries — while zsh keeps working, so it is easy to
miss. Move the lines into `00-path.sh` and delete the file. Check with:

```sh
env -i HOME="$HOME" bash -lc 'echo $EDITOR; type -t ta'
```

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
machine at all". Nothing here runs automatically: no stow package, no login
hook, `bootstrap.sh` ignores it. You run these by hand.

`10-env.sh` already points `brew bundle` at this machine's file, so **no `--file`
flag is ever needed** in a normal shell.

### I installed something and want to keep it

```
brew bundle add --cask obsidian --install   # install it AND write it down
dots sync
```

`--cask` for apps, nothing for formulae. Add it to `brew/Brewfile.common`
instead with `--file=brew/Brewfile.common` if all three Macs should have it.

### I pruned the Brewfile and want those apps gone

```
brew bundle cleanup     # prints the list, asks y/n, then uninstalls
dots sync
```

Not a dry run — it asks, then does it. `--force` skips the question.

### Is this machine what the file says?

```
brew bundle check       # lists anything missing
brew bundle install     # installs the missing ones
```

### Setting up another Mac

```
cd ~/dotfiles && dots sync
brew bundle cleanup     # 1. what is here that is not written down? (answer n)
brew bundle check       # 2. what is written down but missing?
brew bundle add --cask X            # 3. promote keepers, this machine
brew bundle add --cask X --file=brew/Brewfile.common    #    or all machines
brew bundle install     # 4. install the rest
```

Survey first, install last, or you install forty things before seeing what was
already there.

### The files

```
brew/Brewfile.common       # all three Macs: every formula, the universal casks
brew/Brewfile.maxbookpro   # + everything else (this one is the superset)
brew/Brewfile.mini         # + office extras
brew/Brewfile.air          # + daily-driver extras
brew/MANUAL.md             # the handful Homebrew cannot install
```

Each machine file `instance_eval`s the common one (Brewfiles are Ruby), which is
why one `--file` covers both. Never point a command at `Brewfile.common`
directly: it has no machine entries, so `cleanup` would offer to remove them all.

The file is chosen by `uname -n`, lowercased — `MaxBookPro` gives
`Brewfile.maxbookpro`. If a machine's hostname does not match a file, rename the
file or set a short hostname once:

```sh
sudo scutil --set ComputerName mini
sudo scutil --set HostName mini
sudo scutil --set LocalHostName mini
```

### Two things that will bite

**Never run `brew bundle dump` at these paths.** It rewrites the whole file and
destroys the `instance_eval` lines. `add` appends; dump goes to a scratch path.

**`--no-upgrade` is already set for you** (`HOMEBREW_BUNDLE_NO_UPGRADE=1` in
`10-env.sh`). Without it `brew bundle` counts *outdated* as missing, so `check`
cries wolf and `install` turns into a mass upgrade of the whole machine.
Upgrading is `upd`'s job.
