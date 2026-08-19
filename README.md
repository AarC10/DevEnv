# DevEnv

Dotfiles and machine setup scripts. Two machines tracked right now:
Fedora 44 (KDE) on the Framework (full setup, `install.sh`), and a work
Ubuntu 24.04 (GNOME) laptop (just the CLI QoL layer, base dev tooling
already there). Older stuff from prior machines lives in `custom_scripts/`.

## Layout

```
install.sh              runs the full Fedora setup, in order
scripts/
  lib/common.sh           shared vars/helpers, sourced by everything else
  fedora/                  dnf5 calls, KDE-specific stuff
  ubuntu/                   apt calls (currently just the QoL package list)
  common/                   distro-agnostic (cargo, pip, npm, curl installs)
.zshrc, config/, konsole/, kde/    tracked config files scripts copy into place
```

Every script under `scripts/` runs standalone:

```sh
sudo -v                          # cache password once
bash install.sh                   # everything
bash scripts/common/rust.sh        # just this
bash scripts/fedora/packages.sh     # just this
```

Idempotent - re-running skips what's already done. `install.sh` intentionally
leaves out `esp-idf.sh`, `android-studio.sh`, and `spicetify.sh` (bigger,
more optional) - run those by hand when you want them.

Not scripted at all, no reasonable way to automate: JetBrains IDEs (Toolbox
GUI), SEGGER J-Link + STM32CubeProgrammer/CubeMX (vendor sites, account
required). `OPENAI_API_KEY` goes in `~/.config/secrets/env.zsh` by hand,
never in this repo.

## Config files

Tracked here, copied into place by their matching script:

| File | Goes to |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `config/.aliases` | `~/.aliases` |
| `konsole/MesloLGS.profile` | `~/.local/share/konsole/MesloLGS.profile` |
| `kde/spectaclerc` | `~/.config/spectaclerc` |
| `custom_scripts/rsed` | `~/.local/bin/rsed` |

`config/.gitconfig` is reference only - the real aliases live in
`git config --global`, and the `user.*` fields here are placeholder junk on
purpose (this repo's public).

## Work laptop (Ubuntu 24.04, GNOME)

Base dev tooling's already set up there - this is just the CLI QoL layer
(eza/zoxide/fzf/bat/fd/delta), added on top, not a full install:

```sh
bash scripts/ubuntu/packages.sh     # eza, zoxide, fzf, fd, bat, ripgrep, delta
bash scripts/common/git-extras.sh    # git aliases + core.editor
bash scripts/common/zoxide-delta-config.sh
bash scripts/common/lazygit.sh
```

Then add one line to your own `.zshrc` (doesn't overwrite it, unlike the
Framework's `.zshrc`):

```sh
source /path/to/DevEnv/config/qol.zsh
```

No GNOME desktop changes (dock, keybindings, etc.) - deliberately left
alone on a managed machine.

## Neovim

`nvim-config` submodule points at `AarC10/nvim-config` (my actual config,
not currently kept up to date). The Framework runs a fresh LazyVim starter
instead for now - swap back if the submodule gets some attention.

## KDE

`kde/plasma-layout-snapshot.js` is a `dumpCurrentLayoutJS` capture of the
panel layout, replayed by `scripts/fedora/kde-layout.sh` via
`plasma.loadSerializedLayout()` - restores exactly what was live when taken,
not rebuilt from scratch. Re-take it after tuning the layout by hand and
wanting that as the new baseline:

```sh
qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.dumpCurrentLayoutJS > kde/plasma-layout-snapshot.js
```

`kde/kdeglobals` and `kde/MainUbuntu.layout.latte` are reference copies from
a prior machine, not applied anywhere. The Latte layout's there in case
Latte Dock ever makes it to Fedora/Flathub - not packaged there right now.

## `custom_scripts/`

Grab bag from older machines, not audited against the current setup.
`installer/deprecated/` is fully replaced by the scripts above, kept around
in case any of it's useful reference later.
