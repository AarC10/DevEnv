#!/bin/bash
# Create ~/Development structure
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Creating ~/Development structure"
mkdir -p "$DEV/WildWestRocketry" "$DEV/Launch" "$DEV/AarC10" "$DEV/dotfiles"
