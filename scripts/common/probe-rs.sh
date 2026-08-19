#!/bin/bash
# probe-rs-tools (cargo-embed, cargo-flash, probe-rs)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing probe-rs-tools (cargo-embed, cargo-flash, probe-rs)"
export PATH="$USER_HOME/.cargo/bin:$PATH"
if command -v probe-rs &>/dev/null; then
  echo "probe-rs already installed, skipping."
  exit 0
fi
cargo install probe-rs-tools
