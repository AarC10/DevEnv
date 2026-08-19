#!/bin/bash
# Plasma panel layout + KWin window button order
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Restoring Plasma panel layout from snapshot + KWin window button order"
# kde/plasma-layout-snapshot.js is a straight `dumpCurrentLayoutJS` capture,
# replayed via `plasma.loadSerializedLayout()` - restores exactly what was
# live when it was taken, not a hand-built layout.
#
# History: the original version of this script built the layout from
# scratch each run (new Panel, addWidget, ...), working around org.kde.
# plasma.appmenu/panelspacer being broken (Qt ABI mismatch, a Fedora
# packaging bug). That rebuild-from-scratch approach ended up clobbering
# layout changes made by hand after the fact - this snapshot/replay version
# avoids that by only ever restoring a deliberately-taken snapshot. Re-take
# one with `qdbus-qt6 org.kde.plasmashell /PlasmaShell
# org.kde.PlasmaShell.dumpCurrentLayoutJS > kde/plasma-layout-snapshot.js`
# after you've tuned things by hand and want the new state as the baseline.
#
# The broken native panelspacer is moot now anyway - current layout uses
# luisbocanegra.panelspacer.extended (a QML community widget, sidesteps the
# native plugin's Qt ABI issue entirely).
#
# If panels vanish after running this (plasmashell can exit without
# restarting on a config reload): nohup /usr/bin/plasmashell >/dev/null 2>&1 & disown

if ! command -v qdbus-qt6 &>/dev/null; then
  echo "  qdbus-qt6 not found, skipping desktop layout."
  exit 0
fi
if ! qdbus-qt6 org.kde.plasmashell /PlasmaShell &>/dev/null; then
  echo "  plasmashell not running, skipping desktop layout."
  exit 0
fi

qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$REPO_ROOT/kde/plasma-layout-snapshot.js")"

# Window titlebar buttons: Close, Maximize/Restore, Minimize - on the left.
# Must be under [org.kde.kdecoration2], NOT [Windows] (easy mistake - that's
# the wrong group and KWin silently ignores it).
if ! grep -q '^\[org.kde.kdecoration2\]' "$USER_HOME/.config/kwinrc" 2>/dev/null; then
  printf '\n[org.kde.kdecoration2]\nButtonsOnLeft=XAI\nButtonsOnRight=\n' >> "$USER_HOME/.config/kwinrc"
else
  sed -i '/^\[org.kde.kdecoration2\]/,/^\[/{s/^ButtonsOnLeft=.*/ButtonsOnLeft=XAI/; s/^ButtonsOnRight=.*/ButtonsOnRight=/}' "$USER_HOME/.config/kwinrc"
fi
qdbus-qt6 org.kde.KWin /KWin org.kde.KWin.reconfigure &>/dev/null || true

echo "NOTE: split-view shortcut (Ctrl+Shift+S) and Konsole color scheme are"
echo "      NOT scripted here - set those by hand once in Konsole's"
echo "      Settings > Configure Keyboard Shortcuts (search 'split')."
