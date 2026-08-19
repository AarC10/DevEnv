#!/bin/bash
# Write ~/.zshrc from the tracked template
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Writing ~/.zshrc"
cp "$REPO_ROOT/.zshrc" "$USER_HOME/.zshrc"
echo "NOTE: run 'p10k configure' interactively afterward to generate ~/.p10k.zsh"
