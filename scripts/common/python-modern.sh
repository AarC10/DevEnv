#!/bin/bash
# ruff + uv
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing ruff + uv"
pip3 install --user --break-system-packages -U ruff
curl -LsSf https://astral.sh/uv/install.sh | sh
