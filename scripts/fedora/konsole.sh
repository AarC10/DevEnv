#!/bin/bash
# Konsole profile (font, transparency, default shell)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Configuring Konsole (MesloLGS profile, default shell, transparency)"
mkdir -p "$USER_HOME/.local/share/konsole"
cp "$REPO_ROOT/konsole/MesloLGS.profile" "$USER_HOME/.local/share/konsole/MesloLGS.profile"

mkdir -p "$USER_HOME/.config"
konsolerc="$USER_HOME/.config/konsolerc"
if [ -f "$konsolerc" ] && grep -q "^\[Desktop Entry\]" "$konsolerc"; then
  sed -i 's/^DefaultProfile=.*/DefaultProfile=MesloLGS.profile/' "$konsolerc"
else
  { echo "[Desktop Entry]"; echo "DefaultProfile=MesloLGS.profile"; echo; cat "$konsolerc" 2>/dev/null; } > "$konsolerc.tmp"
  mv "$konsolerc.tmp" "$konsolerc"
fi
