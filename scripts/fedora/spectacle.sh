#!/bin/bash
# Spectacle (screenshot tool) settings + shortcut
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Applying Spectacle (screenshot tool) settings + shortcut"
mkdir -p "$USER_HOME/.config"
cp "$REPO_ROOT/kde/spectaclerc" "$USER_HOME/.config/spectaclerc"

# Disables the "Record Window" global shortcut (the other two Spectacle
# keys in this group - CurrentMonitorScreenShot/OpenWithoutScreenshot -
# are blank by Plasma's own default, not a customization, confirmed by
# diffing a fresh install against the main PC's config).
kgs="$USER_HOME/.config/kglobalshortcutsrc"
if grep -q "^\[services\]\[org.kde.spectacle.desktop\]" "$kgs" 2>/dev/null; then
  grep -q "^RecordWindow=" "$kgs" || \
    sed -i '/^\[services\]\[org.kde.spectacle.desktop\]/a RecordWindow=none' "$kgs"
fi
