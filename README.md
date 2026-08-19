# DevEnv

Dotfiles and machine setup scripts. Fedora 44 (KDE) on the Framework is the
current target. Older stuff from prior machines lives in `custom_scripts/`.

## Layout

```
install.sh              run everything below in order
scripts/
  lib/common.sh           shared vars/helpers, sourced by everything else
  fedora/                  dnf5 calls, KDE-specific stuff
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

## Neovim

`nvim-config` submodule points at `AarC10/nvim-config` (my actual config,
not currently kept up to date). The Framework runs a fresh LazyVim starter
instead for now - swap back if the submodule gets some attention.

## KDE

`kde/kdeglobals` and `kde/MainUbuntu.layout.latte` are reference copies from
a prior machine, not applied anywhere. The Latte layout's there in case
Latte Dock ever makes it to Fedora/Flathub - not packaged there right now.

## `custom_scripts/`

Grab bag from older machines, not audited against the current setup.
`installer/deprecated/` is fully replaced by the scripts above, kept around
in case any of it's useful reference later.
