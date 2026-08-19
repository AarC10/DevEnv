#!/bin/bash
# Shared helpers, sourced by every script in scripts/*/. Not run directly.
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/../.." && pwd)"
USER_HOME="$HOME"
DEV="$USER_HOME/Development"

log() { echo -e "\n==> $*"; }
