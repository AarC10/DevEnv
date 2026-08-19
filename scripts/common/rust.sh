#!/bin/bash
# Install Rust (rustup)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Rust (rustup)"
if command -v rustc &>/dev/null; then
  echo "Rust already installed, skipping."
  exit 0
fi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
