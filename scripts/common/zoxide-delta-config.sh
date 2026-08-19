#!/bin/bash
# delta wired into git (zoxide hook lives in .zshrc)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Wiring delta into git"
# zoxide's shell hook lives in .zshrc (Framework) or config/qol.zsh (Ubuntu),
# not here - this only handles git's global config.
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
