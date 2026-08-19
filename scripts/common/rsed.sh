#!/bin/bash
# Install rsed
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing rsed"
mkdir -p "$USER_HOME/.local/bin"
cp "$REPO_ROOT/custom_scripts/rsed" "$USER_HOME/.local/bin/rsed"
chmod +x "$USER_HOME/.local/bin/rsed"
