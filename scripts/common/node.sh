#!/bin/bash
# nvm + corepack/pnpm
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing nvm + corepack/pnpm"
if [ ! -d "$USER_HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$USER_HOME/.nvm"
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"
nvm install --lts
corepack enable
corepack prepare pnpm@latest --activate
