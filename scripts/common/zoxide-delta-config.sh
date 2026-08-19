#!/bin/bash
# delta wired into git (zoxide hook lives in .zshrc)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Wiring zoxide into the shell + delta into git"
# zoxide's shell hook goes directly in the .zshrc heredoc below (see
# 'zoxide init zsh' line) - this section only handles the git side, which
# is global config rather than a file template.
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
