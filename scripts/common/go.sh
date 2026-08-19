#!/bin/bash
# Install Go (manual tarball)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Go (manual tarball, avoids sudo/system dirs)"
go_version="1.26.6"
if [ -x "$USER_HOME/.local/go/bin/go" ]; then
  echo "Go already installed, skipping."
  exit 0
fi
tmp="/tmp/go.tar.gz"
curl -fL -o "$tmp" "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
rm -rf "$USER_HOME/.local/go"
tar -C "$USER_HOME/.local" -xzf "$tmp"
rm -f "$tmp"
mkdir -p "$USER_HOME/go/bin"
