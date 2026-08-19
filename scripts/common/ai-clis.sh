#!/bin/bash
# OpenAI Codex CLI + Gemini CLI
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing OpenAI Codex CLI + Gemini CLI"
export NVM_DIR="$USER_HOME/.nvm"
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"
npm install -g @openai/codex @google/gemini-cli
