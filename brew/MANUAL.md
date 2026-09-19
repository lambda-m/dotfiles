# Apps Homebrew cannot install

Everything else lives in `Brewfile.common` and the per-machine files next to it.
This is the residue: what has to be done by hand on a fresh machine, and why.
Keep it short — if this file grows, something has gone wrong.

## Needs a password (`sudo`), but Homebrew does the work

These are `.pkg` casks. `brew bundle install` runs Apple's installer, which
prompts for a password, so they cannot be installed unattended:

```
zoom  elgato-stream-deck  focusrite-control  filebot  naps2  garmin-express
```

Nothing to do by hand — just be at the keyboard when `brew bundle install` runs.

## No cask exists — download by hand

| App | Where | Note |
|---|---|---|
| VMware Fusion | broadcom.com (free for personal use, account required) | |
| Epson Scan 2 | epson.com support → your scanner model | `/Applications/Epson Software/` |
| KensingtonWorks | kensington.com → downloads | trackball config; note the space in `KensingtonWorks .app` |

## Cask existed once, now disabled

Homebrew disabled these; three of them in a Gatekeeper sweep on 2026-09-01. They
are installed by hand and will not be managed:

| App | Cask disabled | Reason |
|---|---|---|
| darktable | 2026-09-01 | fails macOS Gatekeeper check |
| digiKam | 2026-09-01 | fails macOS Gatekeeper check |
| Disk Inventory X | 2026-09-01 | fails macOS Gatekeeper check |
| Apptivate | 2025-12-23 | no longer meets cask criteria |

Worth re-checking occasionally — `brew info --cask <name>` says if it is back.

## Mac App Store

`mas` is **not installed** here. It is worth adding (`brew install mas`) but know
what it can and cannot do before relying on it:

- It **cannot purchase** apps, and cannot do the first-time "Get" on a free one.
  The app must already be in the Apple Account's purchase history. So on machine
  #2 and #3 `mas install` works; on a brand-new Apple Account it does not.
- `mas signin` was **removed** — Apple deleted the private API. Sign in through
  the App Store GUI first; `mas` piggybacks on that session.
- Since macOS 26.1 it escalates via `sudo`, so expect a password prompt.
- It finds installed apps through **Spotlight**. On a freshly restored machine,
  run `sudo mdutil -Eai on` and let indexing settle or `mas` will hang or report
  apps as missing.

Apps currently from the App Store on this machine:

```
Amphetamine           Numbers                 WhatsApp
Bitwarden             Numbers Creator Studio  Windows App
Disk Speed Test       Pages                   WireGuard
GarageBand            Phiewer (lite)          Yubico Authenticator
iMovie                Keynote
```

Bitwarden, WhatsApp and Yubico Authenticator **also exist as casks** — moving
those three out of the App Store would shrink this list from 14 to 11 and make
them installable unattended.

To add them to the manifest, install `mas`, then `mas list` for the IDs and add
lines like `mas "Amphetamine", id: 937984704` to `Brewfile.common`.

## Not from Homebrew at all

- **Claude Code** — installed natively to `~/.local/bin/claude`, self-updating.
  The `claude` *cask* is the separate Claude Desktop app, which is not installed.
- **Xcode** — managed by the `xcodes` formula, which is in `Brewfile.common`.
- **rustup / cargo** — rustup owns `~/.cargo/bin`; not tracked here.
