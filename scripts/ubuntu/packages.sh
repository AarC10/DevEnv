#!/bin/bash
# CLI quality-of-life packages, apt (Ubuntu 24.04)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing CLI quality-of-life packages (apt)"
sudo apt update
sudo apt install -y eza zoxide fzf fd-find bat ripgrep git-delta

# Debian/Ubuntu ship fd-find and bat under different binary names to avoid
# clashing with existing packages - symlink the expected names into
# ~/.local/bin (needs to come before /usr/bin on PATH).
mkdir -p "$USER_HOME/.local/bin"
ln -sf "$(command -v fdfind)" "$USER_HOME/.local/bin/fd"
ln -sf "$(command -v batcat)" "$USER_HOME/.local/bin/bat"
