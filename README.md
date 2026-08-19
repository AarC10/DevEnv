# DevEnv

Personal dev environment setup — dotfiles, install scripts, and machine
notes. Currently tracks a Fedora 44 (KDE Plasma) Framework laptop as the
primary target; older scripts from prior machines are kept under
`custom_scripts/` for reference.

## Fedora / Framework laptop setup

- **`setup.sh`** — the actual installer. Idempotent, safe to re-run, broken
  into functions you can run individually: `bash setup.sh zephyr rust`, or
  `bash setup.sh` with no args to run everything. `sudo -v` first to cache
  your password once.
- **`CHECKLIST.md`** — what's set up, why, and every non-obvious gotcha hit
  along the way (Fedora package-name renames, dnf5 syntax differences,
  ordering requirements, things that turned out to be Fedora packaging bugs
  rather than anything fixable here). Read this before touching `setup.sh`.
- **`USER_MANUAL.md`** — usage reference for everything `setup.sh` installs:
  actual commands, keybindings, example workflows. Read this to learn what
  you now have available, not how it got installed.
- **`PORTING_CANDIDATES.html`** — working doc used while triaging what to
  pull over from the main PC. Point-in-time artifact of that process, not
  actively maintained.

Config files `setup.sh` copies into place, tracked here as the source of
truth rather than embedded inline:

| File | Goes to |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `config/.aliases` | `~/.aliases` |
| `config/.gitconfig` | reference template only — real values live in `git config --global`, not copied verbatim (this file's `user.*` fields are intentionally placeholder junk, since this repo is public) |
| `konsole/MesloLGS.profile` | `~/.local/share/konsole/MesloLGS.profile` |
| `kde/spectaclerc` | `~/.config/spectaclerc` |
| `custom_scripts/rsed` | `~/.local/bin/rsed` |

Secrets (API keys, tokens) are **never** committed here — `setup.sh` points
at `~/.config/secrets/env.zsh` for that, which lives outside this repo and
is populated by hand.

### Neovim

`nvim-config` is a submodule pointing at `AarC10/nvim-config` (this repo's
own personal config). The Framework laptop currently runs a freshly
bootstrapped [LazyVim](https://www.lazyvim.org/) starter instead
(`section_lazyvim` in `setup.sh`) rather than this submodule, since it was
badly stale at the time of setup. Revisit if `nvim-config` gets updated.

### KDE

- `kde/kdeglobals` — reference copy of a prior machine's KDE color/font
  globals, not currently applied by `setup.sh`.
- `kde/MainUbuntu.layout.latte` — an exported [Latte
  Dock](https://github.com/KDE/latte-dock) layout from a prior machine.
  Latte Dock isn't packaged for Fedora 44 (not in the official repos or on
  Flathub, project's been semi-unmaintained since its original maintainer
  stepped back) — kept here in case that changes and it becomes worth
  installing.

## Older scripts (`custom_scripts/`)

Personal scripts from prior machines/distros, largely predating `setup.sh`.
Not audited or updated as part of the Fedora setup — some (`repos.sh`,
`ca_crap/`, `ros/`) reference tools or repo layouts not currently in use on
this machine. `custom_scripts/installer/deprecated/` holds installers fully
superseded by `setup.sh` (kept for reference, not run).
