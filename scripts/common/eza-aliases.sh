#!/bin/bash
# eza (modern ls) aliases
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Writing eza (modern ls) aliases to ~/.aliases"
cp "$REPO_ROOT/config/.aliases" "$USER_HOME/.aliases"
