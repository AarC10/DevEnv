#!/bin/bash
# LazyVim (Neovim starter config)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing LazyVim (Neovim starter config)"
if [ -d "$USER_HOME/.config/nvim/lua" ]; then
  echo "  ~/.config/nvim already has a config, skipping (won't overwrite)."
  exit 0
fi
git clone https://github.com/LazyVim/starter "$USER_HOME/.config/nvim"
rm -rf "$USER_HOME/.config/nvim/.git"
# Pre-bootstraps plugins + compiles treesitter parsers so the first real
# launch isn't the one paying that cost.
nvim --headless "+Lazy! sync" +qa || true
