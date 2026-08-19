#!/bin/bash
# Install 'just' command runner
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing 'just' command runner"
export PATH="$USER_HOME/.cargo/bin:$PATH"
if command -v just &>/dev/null; then
  echo "just already installed, skipping."
  exit 0
fi
cargo install just
